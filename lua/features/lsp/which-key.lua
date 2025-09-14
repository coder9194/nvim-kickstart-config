vim.keymap.del({ 'n', 'v' }, 'gra')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'grt')

return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { 'gd', group = 'Go to Definition' },
      { 'gi', group = 'Go to Implementation' },
      { 'gr', group = 'Go to Reference' },
      { 'gy', group = 'Go to Type Definition' },
      { 'gD', group = 'Go to Declaration' },
      { '<leader>l', group = 'LSP' },
    },
  },
}
