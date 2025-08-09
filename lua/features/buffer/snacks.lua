return {
  'folke/snacks.nvim',
  -- stylua: ignore
  keys = {
    { '<leader>bg', function() Snacks.picker.grep_buffers() end, desc = 'Grep Opened Buffers', },
    { '<leader>bs', function() Snacks.picker.buffers() end, desc = 'Buffers', },
  },
}
