return {
  {
    'echasnovski/mini.ai',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      custom_textobjects = {
        -- `b` for all brackets
        b = { { '%b()', '%b[]', '%b{}' }, '^.().*().$' },
        B = false,
        -- `q` for all quotes
        q = { { [[%b'']], [[%b""]], [[%b``]] }, '^.().*().$' },
      },
    },
  },
  {
    'folke/which-key.nvim',
    opts_extend = {
      'spec',
    },
    opts = {
      spec = {
        { mode = 'v', 'ab', desc = 'bracket ({[' },
        { mode = 'v', 'ib', desc = 'bracket ({[' },
        { mode = 'v', 'aq', desc = [[quote `"']] },
        { mode = 'v', 'iq', desc = [[quote `"']] },
      },
    },
  },
}
