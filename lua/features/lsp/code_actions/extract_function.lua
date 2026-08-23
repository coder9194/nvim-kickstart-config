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

  local function is_partial_word_selection(s_r, s_c, e_r, e_c)
    local lines = vim.api.nvim_buf_get_lines(bufnr, s_r, e_r + 1, false)
    if #lines == 0 then
      return false
    end

    local start_line = lines[1] or ''
    local end_line = lines[#lines] or ''

    if s_c > 0 then
      local char_before = start_line:sub(s_c, s_c)
      if char_before:match '[%a%d_$]' then
        return true
      end
    end

    if e_c < #end_line then
      local char_after = end_line:sub(e_c + 1, e_c + 1)
      if char_after:match '[%a%d_$]' then
        return true
      end
    end

    return false
  end

  -- Node types that represent expressions/variables rather than function statement bodies
  local expression_only_types = {
    number = true,
    string = true,
    identifier = true,
    property_identifier = true,
    member_expression = true,
    call_expression = true,
    new_expression = true,
    binary_expression = true,
    unary_expression = true,
    array = true,
    object = true,
    template_string = true,
    parenthesized_expression = true,
  }

  local function is_valid_function_body_text(text)
    if not text or text:match '^%s*$' then
      return false
    end

    local trimmed = text:gsub('^%s*', '')

    -- Disallow starting with binary operators, but allow comment prefixes (// or /*)
    if trimmed:match '^[%+%-*%^%%=&#%|%?:%]]' then
      return false
    end

    -- If starting with '/' make sure it is a comment (// or /*)
    if trimmed:match '^/[^/*]' then
      return false
    end

    -- Disallow ending with trailing binary operators
    local trailing = text:gsub('%s*$', '')
    if trailing:match '[%+%-*%/%^%%=&#%|%?:]$' then
      return false
    end

    -- Disallow standalone keywords
    if
      trimmed:match '^const%s*$'
      or trimmed:match '^let%s*$'
      or trimmed:match '^var%s*$'
      or trimmed:match '^function%s*$'
      or trimmed:match '^if%s*$'
      or trimmed:match '^else%s*$'
      or trimmed:match '^for%s*$'
      or trimmed:match '^while%s*$'
      or trimmed:match '^return%s*$'
    then
      return false
    end

    return true
  end

  local sel_s_row, sel_s_col, sel_e_row, sel_e_col, stmt_s_row, is_line_visual
  local body_text = ''
  local is_from_visual = false

  -- Read buffer-local selection state directly
  local cached = vim.b[bufnr].__code_action_selection
  if cached and cached.changedtick == vim.api.nvim_buf_get_changedtick(bufnr) then
    if cached.text and not cached.text:match '^%s*$' then
      sel_s_row = cached.s_row
      sel_s_col = cached.s_col
      sel_e_row = cached.e_row
      sel_e_col = cached.e_col
      stmt_s_row = cached.stmt_row
      is_line_visual = cached.is_line_visual
      body_text = cached.text
      is_from_visual = true
    end
  end

  if is_from_visual then
    if is_partial_word_selection(sel_s_row, sel_s_col, sel_e_row, sel_e_col) then
      return nil
    end

    if not is_valid_function_body_text(body_text) then
      return nil
    end

    -- Filter Gate: Reject inline variable/value expressions in visual mode
    local ok_node, node = pcall(vim.treesitter.get_node, { bufnr = bufnr, pos = { sel_s_row, sel_s_col } })
    if ok_node and node then
      local n_type = node:type()
      if expression_only_types[n_type] and not is_line_visual then
        local n_s_r, n_s_c, n_e_r, n_e_c = node:range()
        if n_s_r == sel_s_row and n_s_c <= sel_s_col and n_e_r == sel_e_row and n_e_c >= sel_e_col then
          return nil
        end
      end
    end
  else
    -- Normal mode fallback
    local ok_node, node = pcall(vim.treesitter.get_node, { bufnr = bufnr })
    if ok_node and node then
      local stmt_node = find_parent(node, 'expression_statement')
        or find_parent(node, 'lexical_declaration')
        or find_parent(node, 'variable_declaration')
        or find_parent(node, 'statement')

      if not stmt_node then
        return nil
      end

      sel_s_row, sel_s_col, sel_e_row, sel_e_col = stmt_node:range()
      stmt_s_row = sel_s_row
      body_text = vim.treesitter.get_node_text(stmt_node, bufnr)
    end
  end

  if not body_text or body_text:match '^%s*$' or not stmt_s_row then
    return nil
  end

  local display_text = body_text:gsub('%s+', ' ')
  if #display_text > 30 then
    display_text = display_text:sub(1, 27) .. '...'
  end

  return {
    title = string.format("Refactor: Extract Function ('%s')", display_text),
    action = function()
      vim.ui.input({ prompt = 'Extract to function name: ', default = 'newFunction' }, function(fn_name)
        if not fn_name or fn_name == '' then
          return
        end

        local stmt_line = vim.api.nvim_buf_get_lines(bufnr, stmt_s_row, stmt_s_row + 1, false)[1] or ''
        local indent = stmt_line:match '^%s*' or ''

        local is_single_expr = not body_text:match ';'
          and not body_text:match '\n'
          and not body_text:match '^%s*if%s'
          and not body_text:match '^%s*for%s'
          and not body_text:match '^%s*while%s'
          and not body_text:match '^%s*const%s'
          and not body_text:match '^%s*let%s'
          and not body_text:match '^%s*var%s'
          and not body_text:match '^%s*return%s'

        local formatted_body = is_single_expr and ('return ' .. body_text .. ';') or body_text

        local body_lines = vim.split(formatted_body, '\n', { plain = true })
        local indented_body = {}
        for _, line in ipairs(body_lines) do
          table.insert(indented_body, indent .. '  ' .. line)
        end

        local fn_def_lines = {
          indent .. string.format('function %s() {', fn_name),
        }
        for _, line in ipairs(indented_body) do
          table.insert(fn_def_lines, line)
        end
        table.insert(fn_def_lines, indent .. '}')
        table.insert(fn_def_lines, '')

        local call_text = string.format('%s()', fn_name)
        if not is_single_expr then
          call_text = call_text .. ';'
        end

        local end_line_text = vim.api.nvim_buf_get_lines(bufnr, sel_e_row, sel_e_row + 1, false)[1] or ''
        local is_full_line_range = is_line_visual or (sel_s_col == 0 and sel_e_col >= #end_line_text)

        -- 1. Replace selected line range FIRST
        if is_full_line_range then
          vim.api.nvim_buf_set_lines(bufnr, sel_s_row, sel_e_row + 1, false, { indent .. call_text })
        else
          local replacement_lines = vim.split(call_text, '\n', { plain = true })
          vim.api.nvim_buf_set_text(bufnr, sel_s_row, sel_s_col, sel_e_row, sel_e_col, replacement_lines)
        end

        -- 2. Insert extracted function definition ABOVE target statement row SECOND
        vim.api.nvim_buf_set_lines(bufnr, stmt_s_row, stmt_s_row, false, fn_def_lines)

        -- Clear selection state after completion
        vim.b[bufnr].__code_action_selection = nil
      end)
    end,
  }
end
