return {
  -- A task runner and job management plugin for Neovim
  -- https://github.com/stevearc/overseer.nvim
  {
    'stevearc/overseer.nvim',
    -- TODO: resolve breaking changes to 2.0 (https://github.com/stevearc/overseer.nvim/releases)
    version = '1.6',
    config = function()
      -- Register custom component
      require 'overseer.component.my_component.init'

      -- Add hooks to run templates in headless nvim to prevent main thread being slow
      require('overseer').add_template_hook({}, function(task_defn, util)
        local raw_cmd = task_defn.cmd
        if not raw_cmd then
          return
        end

        -- Combine task_defn.cmd and task_defn.args into a single list
        local full_cmd_list = {}

        if type(raw_cmd) == 'string' then
          table.insert(full_cmd_list, raw_cmd)
        elseif type(raw_cmd) == 'table' then
          for _, v in ipairs(raw_cmd) do
            table.insert(full_cmd_list, v)
          end
        end

        if task_defn.args and type(task_defn.args) == 'table' then
          for _, v in ipairs(task_defn.args) do
            table.insert(full_cmd_list, v)
          end
        end

        -- Clear task_defn.args so Overseer does not append orphaned arguments to nvim
        task_defn.args = nil

        local first_arg = full_cmd_list[1] or ''
        local lua_expr = ''

        if first_arg:match '^lua%s+' then
          lua_expr = first_arg
        else
          local full_cmd_str = table.concat(full_cmd_list, ' ')
          local escaped_cmd = full_cmd_str:gsub('\\', '\\\\'):gsub('"', '\\"')
          lua_expr = string.format('lua os.execute("%s")', escaped_cmd)
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

      require('utils.overseer').load_custom_templates()
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
