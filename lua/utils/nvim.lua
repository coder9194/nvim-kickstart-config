local M = {}

-- Send keyboard keys to perform function mapped with keymap
function M.send_keys(keymap)
  local keys = vim.api.nvim_replace_termcodes(keymap, true, false, true)
  vim.api.nvim_feedkeys(keys, 'm', false)
end

-- Get current cursor position
-- Return `position_in_line, line_number`
function M.get_cursor_position()
  local line_number, position_in_line = unpack(vim.api.nvim_win_get_cursor(0))
  return position_in_line, line_number
end

-- Set cursor position
function M.set_cursor_position(position_in_line, line_number)
  vim.cmd('cal cursor(' .. line_number .. ', ' .. position_in_line + 1 .. ')')
end

-- Get output from Neovim command
---@param command string
---@return string
function M.get_command_output(command)
  local result = vim.api.nvim_exec2(command, { output = true })
  return result.output
end

-- Get name of current workspace
---@return string
function M.get_current_workspace_name()
  local current_directory = vim.fn.getcwd()
  local directory_folders = M.split_to_table(current_directory, '/')
  return directory_folders[#directory_folders]
end

-- Get path of Neovim config folder
---@return string
function M.get_config_path()
  return M.get_command_output 'echo stdpath("config")'
end

-- Get all files in directory
function M.get_files_in_directory(directory)
  local files = vim.fn.readdir(directory)

  return files
end

-- Split string to table by separator
function M.split_to_table(input_string, separator)
  if separator == nil then
    separator = '%s'
  end
  local temporary_table = {}
  for character in string.gmatch(input_string, '([^' .. separator .. ']+)') do
    table.insert(temporary_table, character)
  end
  return temporary_table
end

function M.safely_delete_keymap(mode, lhs)
  if type(mode) == 'table' then
    for _, m in ipairs(mode) do
      pcall(vim.keymap.del, m, lhs)
    end
  else
    pcall(vim.keymap.del, mode, lhs)
  end
end

return M
