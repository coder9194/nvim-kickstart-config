local M = {}

-- Run callback in new tab
---@param params {callback: function, command: string}
function M.run_in_new_tab(params)
  local callback = params.callback or nil
  local command = params.command or nil
  local x_value, y_value = require('utils.nvim').get_cursor_position()

  vim.cmd 'tabe %'
  require('utils.nvim').set_cursor_position(x_value, y_value)
  if callback then
    callback()
  elseif command then
    vim.cmd(command)
  end
end

return M
