return {
  -- A task runner and job management plugin for Neovim
  -- https://github.com/stevearc/overseer.nvim
  {
    'stevearc/overseer.nvim',
    -- TODO: resolve breaking changes to 2.0 (https://github.com/stevearc/overseer.nvim/releases)
    version = '1.6',
    opts = {
      task_list = {
        bindings = {
          ['<C-f>'] = require('utils.overseer').open_floating_window,
        },
      },
      templates = require('utils.lua').concatenate_tables(base_templates, current_workspace_templates),
    },
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

      require('utils.overseer').load_current_workspace_templates()
    end,
    keys = {
      { '<leader>ar', '<cmd>OverseerRunCmd<cr>', desc = 'Run raw command' },
      { '<leader>as', '<cmd>OverseerRun<cr>', desc = 'Select and start task' },
      { '<leader>at', '<cmd>OverseerToggle<cr>', desc = 'Show running tasks' },
      { '<leader>aq', '<cmd>:OverseerQuickAction<cr>', desc = 'Show quick actions of last task' },
    },
  },
}
