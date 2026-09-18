local M = {}

-- Check whether workspace template exists
---@param workspace_name string
function M.check_has_workspace_template(workspace_name)
  local config_path = require('utils.nvim').get_config_path()
  local is_folder_readable = vim.fn.isdirectory(config_path .. '/lua/overseer/template/' .. workspace_name)
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
  local overseer_template_path = nvim_config_path .. '/lua/overseer/template/workspaces'

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
  vim.cmd 'OverseerQuickAction open float'
  vim.wait(require('constants.nvim').WAITING_TIME)
end

-- Load pre-defined templates for current workspace
function M.load_current_workspace_templates()
  local current_workspace_name = require('utils.nvim').get_current_workspace_name()
  local has_current_workspace_template = require('utils.overseer').check_has_workspace_template(current_workspace_name)
  local current_workspace_templates = has_current_workspace_template and require('utils.overseer').get_workspace_templates(current_workspace_name) or {}

  for _, workspace_template in ipairs(current_workspace_templates) do
    require('overseer').load_template(workspace_template)
  end
end

--- Dynamically scan and load all custom overseer templates from a directory module path
---@param dir_path string Module subpath inside lua directory (e.g., "automation/templates" or "overseer/template")
function M.load_custom_templates()
  local dir_path = 'overseer/template/universal'

  -- Resolve physical file paths under Neovim's runtime path
  local search_pattern = string.format('lua/%s/*.lua', dir_path)
  local template_files = vim.api.nvim_get_runtime_file(search_pattern, true)

  for _, file_path in ipairs(template_files) do
    -- Extract file name without directory prefix or .lua extension
    local module_name = file_path:match '([^/]+)%.lua$'

    if module_name and not module_name:find '^_' then
      local full_module = string.format('%s.%s', dir_path:gsub('/', '.'), module_name)

      -- Clear package cache to ensure fresh reloads during dev
      package.loaded[full_module] = nil
      local template_mod = require(full_module)

      if type(template_mod) == 'table' then
        if type(template_mod.register) == 'function' then
          template_mod.register()
        else
          require('overseer').register_template(template_mod)
        end
      end
    end
  end
end

return M
