return {
  -- https://github.com/alex-popov-tech/store.nvim
  'alex-popov-tech/store.nvim',
  dependencies = { 'OXY2DEV/markview.nvim' },
  opts = {},
  cmd = 'Store',
  keys = {
    { '<leader>ps', '<cmd>Store<cr>', desc = 'Store' },
  },
}
