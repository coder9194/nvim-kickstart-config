return {
  -- https://github.com/alex-popov-tech/store.nvim
  'alex-popov-tech/store.nvim',
  dependencies = { 'OXY2DEV/markview.nvim' },
  opts = {
    filetypes = { 'markdown', 'quarto', 'rmd' }, -- Only enable for markdown-related buffers
    buf_ignore = {}, -- Prevents global attachment to tsx, jsx, lua, etc.
  },
  cmd = 'Store',
  keys = {
    { '<leader>ps', '<cmd>Store<cr>', desc = 'Store' },
  },
}
