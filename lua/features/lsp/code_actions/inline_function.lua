---@param node TSNode?
---@param bufnr integer
---@return table? # Code action payload or nil
return function(node, bufnr)
  if not node then
    return nil
  end

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

  -- 1. Identify target function declaration from cursor position
  local fn_decl = find_parent(node, 'function_declaration') or find_parent(node, 'function_definition')
  if not fn_decl then
    return nil
  end

  -- 2. Filter Gate: Must have both a function identifier and a statement block body
  local name_node = fn_decl:field('name')[1]
  local body_node = fn_decl:field('body')[1]
  if not (name_node and body_node) then
    return nil
  end

  local fn_name = vim.treesitter.get_node_text(name_node, bufnr)
  local raw_body_text = vim.treesitter.get_node_text(body_node, bufnr)

  -- Extract inline expression from block body (strip outer braces, return statement, and trailing semicolons)
  local expr_text = raw_body_text:gsub('^%s*{%s*', ''):gsub('%s*}%s*$', ''):gsub('^%s*return%s+', ''):gsub(';%s*$', '')
  if #expr_text == 0 then
    return nil
  end

  local scope = find_parent(fn_decl, 'program') or fn_decl:parent()
  if not scope then
    return nil
  end

  -- 3. Collect call expression usages across scope AST
  local call_usages = {}
  local function collect_calls(curr)
    if not curr then
      return
    end
    if curr:type() == 'call_expression' then
      local fn_ident = curr:field('function')[1] or curr:child(0)
      if fn_ident and fn_ident:id() ~= name_node:id() and vim.treesitter.get_node_text(fn_ident, bufnr) == fn_name then
        local s_row, s_col, e_row, e_col = curr:range()
        table.insert(call_usages, { s_row = s_row, s_col = s_col, e_row = e_row, e_col = e_col })
      end
    end
    for child in curr:iter_children() do
      collect_calls(child)
    end
  end

  collect_calls(scope)

  -- 4. Filter Gate: Only offer action if there is at least 1 call site to inline
  if #call_usages == 0 then
    return nil
  end

  return {
    title = string.format("Refactor: Inline Function '%s'", fn_name),
    action = function()
      -- Sort call sites in REVERSE order (bottom-to-top) to preserve buffer coordinates
      table.sort(call_usages, function(a, b)
        if a.s_row ~= b.s_row then
          return a.s_row > b.s_row
        end
        return a.s_col > b.s_col
      end)

      local replacement_lines = vim.split(expr_text, '\n')
      for _, u in ipairs(call_usages) do
        vim.api.nvim_buf_set_text(bufnr, u.s_row, u.s_col, u.e_row, u.e_col, replacement_lines)
      end

      -- Delete original function declaration node
      local d_s_row, d_s_col, d_e_row, d_e_col = fn_decl:range()
      vim.api.nvim_buf_set_text(bufnr, d_s_row, d_s_col, d_e_row, d_e_col, {})
    end,
  }
end
