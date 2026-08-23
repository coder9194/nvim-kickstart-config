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

  -- 1. Must be inside a variable declarator
  local var_decl = find_parent(node, 'variable_declarator')
  if not var_decl then
    return nil
  end

  -- 2. Filter Gate: Must have both a name and an assigned initializer value
  local name_node = var_decl:field('name')[1]
  local val_node = var_decl:field('value')[1]
  if not (name_node and val_node) then
    return nil
  end

  local var_name = vim.treesitter.get_node_text(name_node, bufnr)
  local val_text = vim.treesitter.get_node_text(val_node, bufnr)

  local stmt = find_parent(var_decl, 'lexical_declaration') or find_parent(var_decl, 'variable_declaration')
  if not stmt then
    return nil
  end

  local scope = find_parent(stmt, 'statement_block') or find_parent(stmt, 'function_declaration') or find_parent(stmt, 'program')
  if not scope then
    return nil
  end

  -- 3. Collect usage occurrences across scope AST
  local usages = {}
  local function collect_usages(curr)
    if not curr then
      return
    end
    if curr:type() == 'identifier' then
      -- Match exact name, excluding the declaration's own name node
      if curr:id() ~= name_node:id() and vim.treesitter.get_node_text(curr, bufnr) == var_name then
        local s_row, s_col, e_row, e_col = curr:range()
        table.insert(usages, { s_row = s_row, s_col = s_col, e_row = e_row, e_col = e_col })
      end
    end
    for child in curr:iter_children() do
      collect_usages(child)
    end
  end

  collect_usages(scope)

  -- 4. Filter Gate: Only offer action if there is at least 1 usage to inline
  if #usages == 0 then
    return nil
  end

  return {
    title = string.format("Refactor: Inline Variable '%s'", var_name),
    action = function()
      -- Sort usages in REVERSE order (bottom-to-top) to preserve buffer coordinates
      table.sort(usages, function(a, b)
        if a.s_row ~= b.s_row then
          return a.s_row > b.s_row
        end
        return a.s_col > b.s_col
      end)

      local replacement_lines = vim.split(val_text, '\n')
      for _, u in ipairs(usages) do
        vim.api.nvim_buf_set_text(bufnr, u.s_row, u.s_col, u.e_row, u.e_col, replacement_lines)
      end

      -- Delete original declaration statement
      local s_row, _, e_row, _ = stmt:range()
      vim.api.nvim_buf_set_lines(bufnr, s_row, e_row + 1, false, {})
    end,
  }
end
