-- 1. Helper function defined at module level
local function notify_lsp_file_created(target_abs)
  local target_buf = vim.fn.bufadd(target_abs)
  vim.fn.bufload(target_buf)

  local target_uri = vim.uri_from_fname(target_abs)
  for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
    client.notify('workspace/didChangeWatchedFiles', {
      changes = {
        {
          uri = target_uri,
          type = 1, -- 1 = File Created
        },
      },
    })
  end
end

local function escape_pattern(str)
  return str:gsub('([^%w])', '%%%1')
end

local function resolve_target_path(source_bufnr, input_path)
  local expanded = vim.fn.expand(input_path)
  if expanded:match '^/' or expanded:match '^%a:' then
    return vim.fn.fnamemodify(expanded, ':p')
  end
  local source_file = vim.api.nvim_buf_get_name(source_bufnr)
  local buffer_dir = (source_file and source_file ~= '') and vim.fn.fnamemodify(source_file, ':h') or vim.fn.getcwd()
  return vim.fn.fnamemodify(buffer_dir .. '/' .. expanded, ':p')
end

local function get_original_function_name(text, node, bufnr)
  if node then
    local function find_identifier(n)
      if not n then
        return nil
      end
      for child in n:iter_children() do
        local c_type = child:type()
        if c_type == 'identifier' or c_type == 'property_identifier' then
          local id_text = vim.treesitter.get_node_text(child, bufnr)
          if id_text and not id_text:match '^(const|let|var|function|async|export|return)$' then
            return id_text
          end
        elseif c_type == 'variable_declarator' or c_type == 'function_declaration' or c_type == 'lexical_declaration' then
          local res = find_identifier(child)
          if res then
            return res
          end
        end
      end
      return nil
    end
    local ts_name = find_identifier(node)
    if ts_name and ts_name ~= '' then
      return ts_name
    end
  end

  if text then
    local name = text:match 'function%s+([%a%d_$]+)'
      or text:match 'const%s+([%a%d_$]+)'
      or text:match 'let%s+([%a%d_$]+)'
      or text:match 'var%s+([%a%d_$]+)'
      or text:match '([%a%d_$]+)%s*='
    if name and name ~= '' then
      return name
    end
  end

  return 'extractedFunction'
end

local function get_identifier_position(bufnr, node, fn_name)
  if node then
    local function find_id_node(n)
      for child in n:iter_children() do
        local c_type = child:type()
        if c_type == 'identifier' or c_type == 'property_identifier' then
          local text = vim.treesitter.get_node_text(child, bufnr)
          if text == fn_name then
            local r, c = child:range()
            return r, c
          end
        else
          local r, c = find_id_node(child)
          if r then
            return r, c
          end
        end
      end
      return nil
    end
    return find_id_node(node)
  end
  return nil
end

local function update_workspace_imports(bufnr, stmt_node, fn_name, source_abs, target_abs)
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  if #clients == 0 then
    return
  end

  local offset_encoding = clients[1].offset_encoding or 'utf-16'
  local params = vim.lsp.util.make_position_params(0, offset_encoding)

  -- Precision targeting: point LSP request directly at the symbol identifier position
  local id_row, id_col = get_identifier_position(bufnr, stmt_node, fn_name)
  if id_row and id_col then
    params.textDocument = vim.lsp.util.make_text_document_params(bufnr)
    params.position = { line = id_row, character = id_col }
  end
  params.context = { includeDeclaration = false }

  local response = vim.lsp.buf_request_sync(bufnr, 'textDocument/references', params, 2000)
  if not response then
    return
  end

  local source_mod_name = vim.fn.fnamemodify(source_abs, ':t:r')
  local escaped_mod_name = escape_pattern(source_mod_name)
  local escaped_fn_name = escape_pattern(fn_name)

  for _, res in pairs(response) do
    if res.result then
      for _, ref in ipairs(res.result) do
        local ref_uri = ref.uri or ref.targetUri
        local ref_path = vim.uri_to_fname(ref_uri)

        if ref_path ~= source_abs and ref_path ~= target_abs then
          local target_buf = vim.fn.bufadd(ref_path)
          vim.fn.bufload(target_buf)

          local lines = vim.api.nvim_buf_get_lines(target_buf, 0, -1, false)
          local ref_dir = vim.fn.fnamemodify(ref_path, ':h')

          local new_rel_path = vim.fs.relpath(ref_dir, target_abs) or target_abs
          new_rel_path = new_rel_path:gsub('%.[jt]sx?$', '')
          if not new_rel_path:match '^%./' and not new_rel_path:match '^%.%./' then
            new_rel_path = './' .. new_rel_path
          end

          for idx, line in ipairs(lines) do
            if line:match 'import%s+.*%b{}%s+from' and line:match(escaped_fn_name) and line:match(escaped_mod_name) then
              local updated_line = line:gsub('from%s+[\'"].*[\'"]', string.format("from '%s'", new_rel_path))
              vim.api.nvim_buf_set_lines(target_buf, idx - 1, idx, false, { updated_line })
            end
          end
        end
      end
    end
  end
end

local function cleanup_source_buffer(bufnr, fn_name, target_abs)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local new_lines = {}
  local source_path = vim.api.nvim_buf_get_name(bufnr)
  local source_dir = vim.fn.fnamemodify(source_path, ':h')

  local rel_path = vim.fs.relpath(source_dir, target_abs) or target_abs
  rel_path = rel_path:gsub('%.[jt]sx?$', '')
  if not rel_path:match '^%./' and not rel_path:match '^%.%./' then
    rel_path = './' .. rel_path
  end

  local is_fn_used_in_source = false
  local escaped_fn_name = escape_pattern(fn_name)

  for _, line in ipairs(lines) do
    local cleaned_line = line

    if line:match '^%s*export%s*%b{}' and line:match('%f[%w_]' .. escaped_fn_name .. '%f[%W_]') then
      if line:match('^%s*export%s*{%s*' .. escaped_fn_name .. '%s*};?%s*$') then
        cleaned_line = nil
      else
        cleaned_line = line:gsub('{%s*' .. escaped_fn_name .. '%s*,%s*', '{ ')
        cleaned_line = cleaned_line:gsub(',%s*' .. escaped_fn_name .. '%s*}', ' }')
        cleaned_line = cleaned_line:gsub(',%s*' .. escaped_fn_name .. '%s*,', ',')
      end
    elseif line:match '^%s*export%s*;?%s*$' then
      cleaned_line = nil
    end

    if cleaned_line then
      table.insert(new_lines, cleaned_line)
      if not line:match '^%s*//' and not line:match '^%s*/%*' then
        if line:match('%f[%w_]' .. escaped_fn_name .. '%f[%W_]') then
          is_fn_used_in_source = true
        end
      end
    end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)

  if is_fn_used_in_source then
    local current_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local last_import_idx = 0
    for idx, line in ipairs(current_lines) do
      if line:match '^%s*import%s' then
        last_import_idx = idx
      end
    end
    local import_line = string.format("import { %s } from '%s';", fn_name, rel_path)
    vim.api.nvim_buf_set_lines(bufnr, last_import_idx, last_import_idx, false, { import_line })
  end
end

---@param bufnr integer
---@return table?
return function(bufnr)
  local statement_types = {
    lexical_declaration = true,
    variable_declaration = true,
    function_declaration = true,
    expression_statement = true,
    export_statement = true,
    statement = true,
  }

  local function find_closest_statement(n)
    local curr = n
    while curr do
      if statement_types[curr:type()] then
        return curr
      end
      curr = curr:parent()
    end
    return nil
  end

  local ok_node, node = pcall(vim.treesitter.get_node, { bufnr = bufnr })
  if not ok_node or not node then
    return nil
  end

  local stmt_node = find_closest_statement(node)

  if stmt_node then
    local parent = stmt_node:parent()
    if parent and parent:type() == 'export_statement' then
      stmt_node = parent
    end
  end

  if not stmt_node then
    return nil
  end

  local sel_s_row, sel_s_col, sel_e_row, sel_e_col = stmt_node:range()
  local body_text = vim.treesitter.get_node_text(stmt_node, bufnr)

  if not body_text or body_text:match '^%s*$' then
    return nil
  end

  local display_text = body_text:gsub('%s+', ' ')
  if #display_text > 30 then
    display_text = display_text:sub(1, 27) .. '...'
  end

  return {
    title = string.format("Refactor: Extract Function to New File ('%s')", display_text),
    action = function()
      local fn_name = get_original_function_name(body_text, stmt_node, bufnr)
      local source_abs = vim.api.nvim_buf_get_name(bufnr)

      vim.ui.input({ prompt = 'Target file path: ', default = './utils.ts' }, function(file_path)
        if not file_path or file_path == '' then
          return
        end

        local target_abs = resolve_target_path(bufnr, file_path)
        local dir = vim.fn.fnamemodify(target_abs, ':h')

        if vim.fn.isdirectory(dir) == 0 then
          vim.fn.mkdir(dir, 'p')
        end

        -- 1. Query LSP references at exact symbol coordinates & update caller imports
        update_workspace_imports(bufnr, stmt_node, fn_name, source_abs, target_abs)

        -- 2. Format export declaration for target file
        local decl_text = body_text
        if not decl_text:match '^%s*export%s+' then
          decl_text = decl_text:gsub('^%s*', '%0export ')
        end
        local fn_def_lines = vim.split(decl_text, '\n', { plain = true })
        table.insert(fn_def_lines, '')

        local file_exists = vim.uv.fs_stat(target_abs) ~= nil
        local export_content = table.concat(fn_def_lines, '\n')

        if file_exists then
          local file = io.open(target_abs, 'a')
          if file then
            file:write('\n' .. export_content)
            file:close()
          end
        else
          local file = io.open(target_abs, 'w')
          if file then
            file:write(export_content)
            file:close()
          end
        end

        -------------------------------------------------------------------
        -- STEP 1: NOTIFY LSP IMMEDIATELY AFTER FILE WRITE & BEFORE IMPORT UPDATE
        -------------------------------------------------------------------
        notify_lsp_file_created(target_abs)

        -------------------------------------------------------------------
        -- STEP 2: QUERY LSP REFERENCES & UPDATE IMPORTS
        -------------------------------------------------------------------
        update_workspace_imports(bufnr, stmt_node, fn_name, source_abs, target_abs)

        -- 3. Delete extracted statement from source buffer
        local end_line_text = vim.api.nvim_buf_get_lines(bufnr, sel_e_row, sel_e_row + 1, false)[1] or ''
        local is_full_line_range = (sel_s_col == 0 and sel_e_col >= #end_line_text)

        if is_full_line_range then
          vim.api.nvim_buf_set_lines(bufnr, sel_s_row, sel_e_row + 1, false, {})
        else
          vim.api.nvim_buf_set_text(bufnr, sel_s_row, sel_s_col, sel_e_row, sel_e_col, {})
        end

        -- 4. Clean source buffer or re-import if referenced locally
        cleanup_source_buffer(bufnr, fn_name, target_abs)

        vim.b[bufnr].__code_action_selection = nil
      end)
    end,
  }
end
