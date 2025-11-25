local M = {}

-- Get file path of current buffer
function M.get_current_buffer_file_path()
  return vim.fn.expand '%:p'
end

-- Get buffer ID of current buffer
function M.get_current_buffer_id()
  return require('utils.nvim').get_command_output "echo bufnr('%')"
end

-- Get file path of target buffer
---@param buffer_id integer
function M.get_file_path(buffer_id)
  return vim.api.nvim_buf_get_name(buffer_id)
end

-- Check if buffer is shown in any window of any tab
---@param buffer_id integer
function M.is_visible(buffer_id)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buffer_id then
      return true
    end
  end
  return false
end

-- Get buffer flags
function M.get_buffer_flags(buf)
  local flags = ''

  -- current / alternate
  if buf == vim.api.nvim_get_current_buf() then
    flags = flags .. '%'
  elseif buf == vim.fn.bufnr '#' then
    flags = flags .. '#'
  else
    flags = flags .. ' '
  end

  -- active / hidden
  if vim.fn.bufwinnr(buf) ~= -1 then
    flags = flags .. 'a'
  elseif vim.api.nvim_buf_is_loaded(buf) then
    flags = flags .. 'h'
  else
    flags = flags .. ' '
  end

  -- readonly
  if vim.bo[buf].readonly then
    flags = flags .. '='
  end

  -- modified
  if vim.bo[buf].modified then
    flags = flags .. '+'
  end

  -- not modifiable
  if not vim.bo[buf].modifiable then
    flags = flags .. '-'
  end

  return flags
end

-- Delete invisible buffers
function M.delete_invisible_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local is_buffer_active = M.get_buffer_flags(buf):find 'a' ~= nil

    if vim.api.nvim_buf_is_valid(buf) and not M.is_visible(buf) and not is_buffer_active then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

-- Open buffer in new tab
function M.open_buffer_in_new_tab()
  local position_in_line, line_number = require('utils.nvim').get_cursor_position()
  vim.cmd 'tabe %'
  require('utils.nvim').set_cursor_position(position_in_line, line_number)
end

-- Reload current buffer
function M.reload()
  vim.cmd 'e!'
  vim.lsp.inlay_hint.enable()
end

return M
