-- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists
-- https://github.com/folke/trouble.nvim

return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {},
  keys = {
    { '<leader>fd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'File Diagnostics' },
  },
}
