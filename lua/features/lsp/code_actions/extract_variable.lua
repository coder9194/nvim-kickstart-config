---@param bufnr integer
---@return table? # Code action payload or nil
return function(bufnr)
  local function find_parent(n, target)
    local curr = n
    while curr do
      if curr:type() == target then
        return curr
      end
      curr = curr:parent()
    end
    return nil
  end

  -- Table of valid JS/TS AST expression node types
  local valid_expr_types = {
    number = true,
    string = true,
    identifier = true,
    binary_expression = true,
    call_expression = true,
    member_expression = true,
    await_expression = true,
    template_string = true,
    array = true,
    object = true,
    unary_expression = true,
    logical_expression = true,
    arrow_function = true,
    function_expression = true,
    conditional_expression = true,
    parenthesized_expression = true,
    property_identifier = true,
    new_expression = true,
  }

  -- Helper to check if visual selection splits a word in the buffer (e.g. "retur" inside "return")
  local function is_partial_word_selection(s_r, s_c, e_r, e_c)
    local lines = vim.api.nvim_buf_get_lines(bufnr, s_r, e_r + 1, false)
    if #lines == 0 then
      return false
    end

    local start_line = lines[1] or ''
    local end_line = lines[#lines] or ''

    -- Check character directly before start column
    if s_c > 0 then
      local char_before = start_line:sub(s_c, s_c)
      if char_before:match '[%a%d_$]' then
        return true
      end
    end

    -- Check character directly after end column
    if e_c < #end_line then
      local char_after = end_line:sub(e_c + 1, e_c + 1)
      if char_after:match '[%a%d_$]' then
        return true
      end
    end

    return false
  end

  -- Helper to check if a text string is a valid standalone expression
  local function is_valid_expression_text(text)
    if not text or text:match '^%s*$' then
      return false
    end

    -- Disallow trailing semicolons (full statements)
    if text:match ';%s*$' then
      return false
    end

    -- Disallow console log/debug/warn/error statements (void return side-effects)
    if text:match '^%s*console%.' then
      return false
    end

    -- Disallow leading or trailing binary operators, statement keywords, or incomplete syntax
    if
      text:match '^%s*[%+%-*%/%=%&%|%^%?%:]'
      or text:match '[%+%-*%/%=%&%|%^%?%:]%s*$'
      or text:match '^%s*return%f[%s%a%d_$]'
      or text:match '^%s*const%f[%s%a%d_$]'
      or text:match '^%s*let%f[%s%a%d_$]'
      or text:match '^%s*var%f[%s%a%d_$]'
      or text:match '^%s*function%f[%s%a%d_$]'
      or text:match '^%s*if%f[%s%a%d_$]'
      or text:match '^%s*else%f[%s%a%d_$]'
      or text:match '^%s*for%f[%s%a%d_$]'
      or text:match '^%s*while%f[%s%a%d_$]'
    then
      return false
    end

    local filetype = vim.bo[bufnr].filetype
    local parser_lang = (filetype == 'typescriptreact' or filetype == 'typescript') and 'typescript' or 'javascript'

    local ok_parse, parser = pcall(vim.treesitter.get_string_parser, text, parser_lang)
    if not ok_parse or not parser then
      return true
    end

    local tree = parser:parse()[1]
    if not tree then
      return false
    end

    local root = tree:root()
    if root:has_error() then
      return false
    end

    local first_child = root:child(0)
    if not first_child then
      return false
    end

    local child_type = first_child:type()
    if first_child:type() == 'expression_statement' then
      first_child = first_child:child(0)
      child_type = first_child and first_child:type() or ''
    end

    return valid_expr_types[child_type] == true
  end

  local s_row, s_col, e_row, e_col
  local expr_text = ''
  local is_from_visual = false

  -- 1. Read directly from buffer-local selection state
  local cached = vim.b[bufnr].__code_action_selection
  if cached and cached.changedtick == vim.api.nvim_buf_get_changedtick(bufnr) then
    if cached.text and not cached.text:match '^%s*$' then
      s_row = cached.s_row
      s_col = cached.s_col
      e_row = cached.e_row
      e_col = cached.e_col
      expr_text = cached.text
      is_from_visual = true
    end
  end

  -- 2. Validate visual selection or fall back to cursor node
  if is_from_visual then
    if is_partial_word_selection(s_row, s_col, e_row, e_col) then
      return nil
    end

    if not is_valid_expression_text(expr_text) then
      return nil
    end
  else
    -- Normal mode / fallback: Get exact AST node under cursor
    local ok_node, node = pcall(vim.treesitter.get_node, { bufnr = bufnr })
    if ok_node and node then
      if not valid_expr_types[node:type()] then
        return nil
      end

      s_row, s_col, e_row, e_col = node:range()
      expr_text = vim.treesitter.get_node_text(node, bufnr)

      if not is_valid_expression_text(expr_text) then
        return nil
      end
    end
  end

  local ok_node, node = pcall(vim.treesitter.get_node, { bufnr = bufnr })
  if not expr_text or expr_text:match '^%s*$' or not node then
    return nil
  end

  -- Locate containing statement for variable insertion line
  local stmt = find_parent(node, 'return_statement')
    or find_parent(node, 'expression_statement')
    or find_parent(node, 'lexical_declaration')
    or find_parent(node, 'variable_declaration')
    or find_parent(node, 'statement')
  if not stmt then
    return nil
  end

  local display_text = expr_text:gsub('%s+', ' ')
  if #display_text > 30 then
    display_text = display_text:sub(1, 27) .. '...'
  end

  return {
    title = string.format("Refactor: Extract Variable ('%s')", display_text),
    action = function()
      vim.ui.input({ prompt = 'Extract to variable name: ', default = 'a' }, function(var_name)
        if not var_name or var_name == '' then
          return
        end

        local stmt_s_row, _, _, _ = stmt:range()
        local stmt_line = vim.api.nvim_buf_get_lines(bufnr, stmt_s_row, stmt_s_row + 1, false)[1] or ''
        local indent = stmt_line:match '^%s*' or ''

        local decl_text = string.format('%sconst %s = %s;', indent, var_name, expr_text)
        local decl_lines = vim.split(decl_text, '\n', { plain = true })

        -- 1. Replace selected expression range with variable identifier FIRST
        local replacement_lines = vim.split(var_name, '\n', { plain = true })
        vim.api.nvim_buf_set_text(bufnr, s_row, s_col, e_row, e_col, replacement_lines)

        -- 2. Insert variable declaration statement directly above target statement SECOND
        vim.api.nvim_buf_set_lines(bufnr, stmt_s_row, stmt_s_row, false, decl_lines)

        -- Clear selection state ONLY after execution completes
        vim.b[bufnr].__code_action_selection = nil
      end)
    end,
  }
end
