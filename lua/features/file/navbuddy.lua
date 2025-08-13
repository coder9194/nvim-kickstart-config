-- A simple popup display that provides breadcrumbs feature using LSP server
-- https://github.com/SmiteshP/nvim-navbuddy

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'SmiteshP/nvim-navbuddy',
        dependencies = {
          'SmiteshP/nvim-navic',
          'MunifTanjim/nui.nvim',
        },
        opts = { lsp = { auto_attach = true } },
      },
    },
  },
  {
    'SmiteshP/nvim-navbuddy',
    dependencies = {
      'neovim/nvim-lspconfig',
      'SmiteshP/nvim-navic',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      window = {
        sections = {
          right = { preview = 'always' },
        },
      },
      -- stylua: ignore
      mappings = {
        ['s'] = { callback = function() require('flash').jump() end, description = 'Flash', },
      },
    },
    keys = {
      { '<leader>fn', mode = 'n', '<cmd>Navbuddy<cr>', desc = 'Symbol Navigation' },
    },
  },
}
