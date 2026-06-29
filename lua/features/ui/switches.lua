require('snacks').toggle
  .new({
    name = 'Text Wrap (Global)',
    get = function()
      return vim.api.nvim_get_option_value('wrap', { scope = 'global' })
    end,
    set = function(state)
      -- 1. Set the global default fallback value for future windows
      vim.api.nvim_set_option_value('wrap', state, { scope = 'global' })

      -- 2. Force the state onto all currently open windows in the active tab
      local windows = vim.api.nvim_tabpage_list_wins(0)
      for _, win in ipairs(windows) do
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_set_option_value('wrap', state, { win = win })
        end
      end
    end,
  })
  :map '<leader>SW'

-- Local (Current Window) Text Wrap Toggle
require('snacks').toggle
  .new({
    name = 'Text Wrap (Local)',
    get = function()
      return vim.api.nvim_get_option_value('wrap', { scope = 'local' })
    end,
    set = function(state)
      vim.api.nvim_set_option_value('wrap', state, { scope = 'local' })
    end,
  })
  :map '<leader>Sw'

return {}
