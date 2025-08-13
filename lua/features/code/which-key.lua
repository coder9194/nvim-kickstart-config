return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { '<leader>c', group = 'Code' },
      { '<leader>cd', group = 'diagnostic' },
      { '<leader>cl', group = 'log' },
      { '<leader>ct', group = 'type' },
    },
  },
  keys = {
    { '<leader>cde', require('utils.code').lint_project_by_eslint, desc = 'Workspace eslint diagnostic' },
    { '<leader>cdr', vim.diagnostic.reset, desc = 'Reset diagnostic list' },
  },
}
