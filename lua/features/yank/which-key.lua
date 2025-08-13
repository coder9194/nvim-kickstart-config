return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { '<leader>y', group = 'Yank' },
      { '<leader>yf', group = 'file' },
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>yff', '<cmd>let @+ = expand("%:p")<cr>', desc = 'Copy file full path' },
    { '<leader>yfr', '<cmd>let @+ = expand("%")<cr>', desc = 'Copy file relative path' },
    { '<leader>yft', '<cmd>let @+ = expand("%:t")<cr>', desc = 'Copy filename' },
  },
}
