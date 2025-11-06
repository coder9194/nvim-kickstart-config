return {
  'folke/snacks.nvim',
  -- stylua: ignore
  keys = {
    { '<leader>bb', "<cmd>e #<cr>", desc = 'Last active buffer', },
    { '<leader>bd', function() require('snacks').bufdelete() vim.cmd 'close' end, desc = 'Delete Current Buffer', },
    { '<leader>bg', function() require('snacks').picker.grep_buffers() end, desc = 'Grep Opened Buffers', },
    { '<leader>bs', function() require('snacks').picker.buffers() end, desc = 'Buffers', },
  },
}
