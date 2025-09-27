return {
  'folke/snacks.nvim',
  -- stylua: ignore
  keys={
    { '<leader><space>', function() require('snacks').picker.resume() end, desc = 'Resume last picker', },
  },
}
