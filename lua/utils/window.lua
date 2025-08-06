local M = {}

-- Swap two windows
---@param target_direction "up" | "right" | "down" | "left"
function M.swap_windows(target_direction)
  local target_key = ''
  local back_key = ''
  if target_direction == 'up' then
    target_key = 'k'
    back_key = 'j'
  elseif target_direction == 'right' then
    target_key = 'l'
    back_key = 'h'
  elseif target_direction == 'down' then
    target_key = 'j'
    back_key = 'k'
  elseif target_direction == 'left' then
    target_key = 'h'
    back_key = 'l'
  end

  require('utils.nvim').send_keys 'mA'
  require('utils.nvim').send_keys('<c-w>' .. target_key)
  require('utils.nvim').send_keys 'mB'
  require('utils.nvim').send_keys "'A"
  require('utils.nvim').send_keys('<c-w>' .. back_key)
  require('utils.nvim').send_keys "'B"
  require('utils.nvim').send_keys('<c-w>' .. target_key)
end

-- Split window to left
function M.split_window_left()
  vim.cmd 'vsplit'
  require('utils.window').swap_windows 'left'
end

-- Split window to up
function M.split_window_up()
  vim.cmd 'split'
  require('utils.window').swap_windows 'up'
end

-- Run callback/command in left window
---@param params {callback: function, command: string}
function M.run_in_left_window(params)
  local callback = params.callback or nil
  local command = params.command or nil

  M.split_window_left()
  vim.wait(require('constants.nvim').WAITING_TIME)
  if callback then
    callback()
  elseif command then
    vim.cmd(command)
  end
end

-- Run callback in below window
---@param params {callback: function, command: string}
function M.run_in_below_window(params)
  local callback = params.callback or nil
  local command = params.command or nil

  vim.cmd 'split'
  vim.cmd "''"
  if callback then
    callback()
  elseif command then
    vim.cmd(command)
  end
end

-- Run callback in above window
---@param params {callback: function, command: string}
function M.run_in_above_window(params)
  local callback = params.callback or nil
  local command = params.command or nil

  M.split_window_up()
  vim.wait(require('constants.nvim').WAITING_TIME)
  vim.cmd "''"
  if callback then
    callback()
  elseif command then
    vim.cmd(command)
  end
end

-- Run callback in right window
---@param params {callback: function, command: string}
function M.run_in_right_window(params)
  local callback = params.callback or nil
  local command = params.command or nil

  vim.cmd 'vsplit'
  if callback then
    callback()
  elseif command then
    vim.cmd(command)
  end
end

-- Set buffer by buffer ID in current window
---@param buffer_id number
function M.set_current_window_buffer(buffer_id)
  vim.cmd(':b ' .. buffer_id)
end

return M
