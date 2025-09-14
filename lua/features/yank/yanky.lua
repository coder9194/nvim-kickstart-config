-- Improve yank and put functionalities
-- https://github.com/gbprod/yanky.nvim

return {
  'gbprod/yanky.nvim',
  opts = {},
  keys = {
    { 'p', '<Plug>(YankyPutAfter)', mode = 'n' },
    { 'P', '<Plug>(YankyPutBefore)', mode = 'n' },
    { 'gp', '<Plug>(YankyGPutAfter)', mode = 'n' },
    { 'gP', '<Plug>(YankyGPutBefore)', mode = 'n' },
    { '<c-p>', '<Plug>(YankyPreviousEntry)', mode = 'n' },
    { '<c-n>', '<Plug>(YankyNextEntry)', mode = 'n' },
  },
}
