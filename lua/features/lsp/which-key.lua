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
  -- stylua: ignore
  keys = {
    { 'Hd', function() vim.diagnostic.jump { count = -1, } end, desc = 'Previous Info', },
    { 'Ld', function() vim.diagnostic.jump { count = 1, } end, desc = 'Next Info', },
    { 'Hw', function() vim.diagnostic.jump { count = -1, severity = 'WARN' } end, desc = 'Previous Warning', },
    { 'Lw', function() vim.diagnostic.jump { count = 1, severity = 'WARN' } end, desc = 'Next Warning', },
    { 'He', function() vim.diagnostic.jump { count = -1, severity = 'ERROR' } end, desc = 'Previous Error', },
    { 'Le', function() vim.diagnostic.jump { count = 1, severity = 'ERROR' } end, desc = 'Next Error', },
  },
}
