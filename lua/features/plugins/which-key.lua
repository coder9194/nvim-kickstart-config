return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { '<leader>p', group = 'Plugins' },
    },
  },
  keys = {
    { '<leader>pm', '<cmd>Lazy<cr>', desc = 'Lazy Plugin Manager' },
  },
}
