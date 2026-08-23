local M = {}

---Retrieve valid cached visual selection for a buffer
---@param bufnr integer
---@return table?
function M.get_selection(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local sel = vim.b[bufnr].__code_action_selection
  if not sel then
    return nil
  end

  -- Invalidate if buffer was modified after selection was captured
  local current_tick = vim.api.nvim_buf_get_changedtick(bufnr)
  if sel.changedtick ~= current_tick then
    return nil
  end

  return sel
end

---Clear cached selection state for a buffer
---@param bufnr integer
function M.clear_selection(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.b[bufnr].__code_action_selection = nil
end

function M.run_code_action()
  local bufnr = vim.api.nvim_get_current_buf()
  local mode = vim.api.nvim_get_mode().mode
  local is_visual_mode = mode:find '[vV\16]' ~= nil

  -- 1. Exit visual mode if active to commit '< and '> marks
  if is_visual_mode then
    vim.cmd 'normal! \27'
  end

  -- 2. Read visual selection range from marks
  local mark_start = vim.fn.getpos "'<"
  local mark_end = vim.fn.getpos "'>"

  local r1, c1 = mark_start[2] - 1, mark_start[3] - 1
  local r2, c2 = mark_end[2] - 1, mark_end[3] - 1

  if r1 >= 0 and r2 >= 0 then
    local s_row = math.min(r1, r2)
    local e_row = math.max(r1, r2)

    local s_col, e_col
    if r1 < r2 then
      s_col, e_col = c1, c2
    elseif r2 < r1 then
      s_col, e_col = c2, c1
    else
      s_col = math.min(c1, c2)
      e_col = math.max(c1, c2)
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, s_row, e_row + 1, false)
    if #lines > 0 then
      local is_line_visual = (mode == 'V') or (s_col == 0 and c2 >= 2147483647)
      local last_line_len = #lines[#lines]

      if is_line_visual then
        s_col = 0
        e_col = last_line_len
      else
        e_col = math.min(e_col + 1, last_line_len)
      end

      -- Calculate top statement row anchor
      local stmt_row = s_row
      local ok_node, node = pcall(vim.treesitter.get_node, { bufnr = bufnr, pos = { s_row, s_col } })
      if ok_node and node then
        local curr = node
        while curr do
          local type = curr:type()
          if type:find 'statement' or type:find 'declaration' then
            stmt_row = curr:range()
            break
          end
          curr = curr:parent()
        end
      end

      -- Format text payload cleanly across all selected lines
      local selected_text = table.concat(lines, '\n')
      if not is_line_visual then
        if #lines == 1 then
          selected_text = string.sub(lines[1], s_col + 1, e_col)
        else
          local formatted = { string.sub(lines[1], s_col + 1) }
          for i = 2, #lines - 1 do
            table.insert(formatted, lines[i])
          end
          table.insert(formatted, string.sub(lines[#lines], 1, e_col))
          selected_text = table.concat(formatted, '\n')
        end
      end

      -- Store selection state in buffer scope with changedtick
      vim.b[bufnr].__code_action_selection = {
        bufnr = bufnr,
        s_row = s_row,
        s_col = s_col,
        e_row = e_row,
        e_col = e_col,
        stmt_row = stmt_row,
        is_line_visual = is_line_visual,
        text = selected_text,
        changedtick = vim.api.nvim_buf_get_changedtick(bufnr),
      }
    end
  end

  vim.lsp.buf.code_action()
end

return M
