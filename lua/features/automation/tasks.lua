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

      -- Add hooks to run templates in headless nvim to prevent main thread being slow
      require('overseer').add_template_hook({}, function(task_defn, util)
        local raw_cmd = task_defn.cmd
        if not raw_cmd then
          return
        end

        local lua_expr = ''

        if type(raw_cmd) == 'string' then
          if raw_cmd:match '^lua%s+' then
            lua_expr = raw_cmd
          else
            lua_expr = string.format('lua os.execute(%s)', vim.inspect(raw_cmd))
          end
        elseif type(raw_cmd) == 'table' then
          if type(raw_cmd[1]) == 'string' and raw_cmd[1]:match '^lua%s+' then
            lua_expr = raw_cmd[1]
          else
            local cmd_str = table.concat(raw_cmd, ' ')
            lua_expr = string.format('lua os.execute(%s)', vim.inspect(cmd_str))
          end
        end

        task_defn.cmd = {
          'nvim',
          '--headless',
          '-c',
          lua_expr,
          '-c',
          'qall!',
        }
      end)

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
