return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { '<leader>f', group = 'File' },
      { '<leader>fn', group = 'new file' },
      { '<leader>fy', group = 'yank' },
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>fnn', '<cmd>enew<cr>', desc = 'In current window' },
    { '<leader>fnh', function() require('utils.window').run_in_left_window { callback = function() vim.cmd 'enew' end, } end, desc = 'In left window', },
    { '<leader>fnj', function() require('utils.window').run_in_below_window { callback = function() vim.cmd 'enew' end, } end, desc = 'In below window', },
    { '<leader>fnk', function() require('utils.window').run_in_above_window { callback = function() vim.cmd 'enew' end, } end, desc = 'In above window', },
    { '<leader>fnl', function() require('utils.window').run_in_right_window { callback = function() vim.cmd 'enew' end, } end, desc = 'In right window', },
  },
}
