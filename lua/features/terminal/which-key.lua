return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { '<leader>T', group = 'Terminal' },
    },
  },
  -- stylua: ignore
  keys = {
    -- vim.keymap.set('n', '<leader>Tnn', '<cmd>te<cr>', { desc = 'In current window' }),
    -- vim.keymap.set('n', '<leader>Tnh', function()
    --   require('utils.window').split_window_left()
    --   vim.wait(require('constants.nvim').WAITING_TIME)
    --   vim.cmd 'te'
    -- end, { desc = 'In left window' }),
    -- vim.keymap.set('n', '<leader>Tnj', function()
    --   vim.cmd 'split'
    --   vim.cmd 'te'
    -- end, { desc = 'In bottom window' }),
    -- vim.keymap.set('n', '<leader>Tnk', function()
    --   require('utils.window').split_window_up()
    --   vim.wait(require('constants.nvim').WAITING_TIME)
    --   vim.cmd 'te'
    -- end, { desc = 'In above window' }),
    -- vim.keymap.set('n', '<leader>Tnl', function()
    --   vim.cmd 'vsplit'
    --   vim.cmd 'te'
    -- end, { desc = 'In right window' }),
    {'<leader>Tnn', '<cmd>te<cr>', desc = 'In current window' },
    {'<leader>Tnh', function() require('utils.window').split_window_left() vim.cmd 'te' end, desc = 'In left window', },
    {'<leader>Tnj', function() vim.cmd 'split' vim.cmd 'te' end, desc = 'In bottom window', },
    {'<leader>Tnk', function() require('utils.window').split_window_up() vim.cmd 'te' end, desc = 'In above window', },
    {'<leader>Tnl', function() vim.cmd 'vsplit' vim.cmd 'te' end, desc = 'In right window', },
  },
}
