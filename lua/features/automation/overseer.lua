-- A task runner and job management plugin for Neovim
-- https://github.com/stevearc/overseer.nvim

local function load_current_workspace_templates()
  local base_templates = { 'builtin' }
  local current_workspace_name = require('utils.nvim').get_current_workspace_name()
  local has_current_workspace_template = require('utils.overseer').check_has_workspace_template(current_workspace_name)
  local current_workspace_templates = has_current_workspace_template and require('utils.overseer').get_workspace_templates(current_workspace_name) or {}

  for _, workspace_template in ipairs(current_workspace_templates) do
    require('overseer').load_template(workspace_template)
  end
end

return {
  'stevearc/overseer.nvim',
  config = function()
    -- Register custom component
    require 'overseer.component.my_component.init'

    require('overseer').setup {
      task_list = {
        bindings = {
          ['<C-f>'] = require('utils.overseer').open_floating_window,
        },
      },
    }

    load_current_workspace_templates()
  end,
  opts = {
    task_list = {
      bindings = {
        ['<C-f>'] = require('utils.overseer').open_floating_window,
      },
    },
    templates = require('utils.lua').concatenate_tables(base_templates, current_workspace_templates),
  },
  keys = {
    { '<leader>ar', '<cmd>OverseerRunCmd<cr>', desc = 'Run raw command' },
    { '<leader>as', '<cmd>OverseerRun<cr>', desc = 'Select and start task' },
    { '<leader>at', '<cmd>OverseerToggle<cr>', desc = 'Show running tasks' },
    { '<leader>aq', '<cmd>:OverseerQuickAction<cr>', desc = 'Show quick actions of last task' },
  },
}
