return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
    lazy = false, -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 5, -- Increases distance from screen edges
        max_width = 80, -- Limits maximum columns
        max_height = 30, -- Limits maximum rows
        border = 'rounded',
      },
      use_default_keymaps = false,
      -- See :help oil-actions for a list of all available actions
      keymaps = {
        ['h'] = require('utils.oil').go_back_within_root,
        ['l'] = 'actions.select',
        ['<cr>'] = 'actions.select',
        ['<esc>'] = 'actions.close',
        ['<c-h>'] = function()
          require('oil').select { vertical = true, split = 'topleft' }
        end,
        ['<c-l>'] = function()
          require('oil').select { vertical = true, split = 'belowright' }
        end,
        ['<c-j>'] = function()
          require('oil').select { horizontal = true, split = 'botright' }
        end,
        ['<c-k>'] = function()
          require('oil').select { horizontal = true, split = 'topleft' }
        end,
      },
    },
    -- stylua: ignore
    keys = {
      { '<leader>fe', function() if vim.bo.filetype ~= 'oil' then require('oil').open_float() end end, desc = 'Explorer (from opened)', },
      { '<leader>fE', function() require('oil').open_float(".") end, desc = 'Explorer (from root)', },
    },
  },
}
