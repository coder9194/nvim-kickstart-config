return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
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
