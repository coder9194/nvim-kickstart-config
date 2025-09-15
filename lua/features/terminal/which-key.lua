return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { '<leader>T', group = 'Terminal' },
      { '<leader>Tn', group = 'New' },
    },
  },
  -- stylua: ignore
  keys = {
    {'<leader>Tnn', '<cmd>te<cr>', desc = 'In current window' },
    {'<leader>Tnh', function() require('utils.window').split_window_left() vim.cmd 'te' end, desc = 'In left window', },
    {'<leader>Tnj', function() vim.cmd 'split' vim.cmd 'te' end, desc = 'In bottom window', },
    {'<leader>Tnk', function() require('utils.window').split_window_up() vim.cmd 'te' end, desc = 'In above window', },
    {'<leader>Tnl', function() vim.cmd 'vsplit' vim.cmd 'te' end, desc = 'In right window', },
  },
}
