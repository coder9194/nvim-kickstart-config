local M = {}

-- Check whether workspace template exists
---@param workspace_name string
function M.check_has_workspace_template(workspace_name)
  local config_path = require('utils.nvim').get_config_path()
  local is_folder_readable = vim.fn.isdirectory(config_path .. require('constants.overseer').WORKSPACE_TEMPLATES_PATH .. workspace_name)
  local has_workspace_template = is_folder_readable == 1

  return has_workspace_template
end

-- Get parent workspace name, used with strategy of git worktree of `<parent>-<sub>`
---@param workspace_name string
---@return string
function M.get_workspace_parent_name(workspace_name)
  local splitted_name_parts = split_to_table(workspace_name, '-')
  local workspace_parent = require('utils.lua').reduce(splitted_name_parts, function(accumulator, current_value, current_index)
    if current_index == 1 then
      return current_value
    elseif current_index < #splitted_name_parts then
      return accumulator .. '-' .. current_value -- Concatenate with separator
    else
      return accumulator
    end
  end, '')

  return workspace_parent
end

function M.get_workspace_templates(workspace_name)
  local nvim_config_path = require('utils.nvim').get_config_path()
  local overseer_template_path = nvim_config_path .. require('constants.overseer').WORKSPACE_TEMPLATES_PATH

  local templates = {}

  local template_files = require('utils.nvim').get_files_in_directory(overseer_template_path .. '/' .. workspace_name)

  for _, template_full_name in ipairs(template_files) do
    local template_name = require('utils.lua').split_string(template_full_name, '.')[1]
    table.insert(templates, workspace_name .. '.' .. template_name)
  end

  return templates
end

-- Open floating window with custom keymaps
function M.open_floating_window()
  local overseer = require 'overseer'
  local tasks = overseer.list_tasks { recent_first = true }
  if tasks[1] then
    overseer.run_action(tasks[1], 'open float')
  else
    require('utils.log').info 'There are no tasks running'
  end
end

-- Load pre-defined templates for current workspace
function M.load_current_workspace_templates()
  local current_workspace_name = require('utils.nvim').get_current_workspace_name()
  local has_current_workspace_template = require('utils.overseer').check_has_workspace_template(current_workspace_name)
  local current_workspace_templates = has_current_workspace_template and require('utils.overseer').get_workspace_templates(current_workspace_name) or {}

  for _, workspace_template in ipairs(current_workspace_templates) do
    local module_path = string.format('overseer.' .. require('constants.overseer').WORKSPACE_TEMPLATE_FOLDER_NAME .. '.%s', workspace_template)

    package.loaded[module_path] = nil
    local ok, template_def = pcall(require, module_path)

    if ok and type(template_def) == 'table' then
      require('overseer').register_template(template_def)
    end
  end
end

return M
