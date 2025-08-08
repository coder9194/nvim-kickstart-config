return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { '<leader>g', group = 'Git' },
      { '<leader>gb', group = 'blame' },
      { '<leader>gc', group = 'conflict' },
      { '<leader>gd', group = 'diff view' },
      { '<leader>gh', group = 'hunk' },
      { '<leader>gg', group = 'graph' },
    },
  },
}
