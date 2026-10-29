return {
  'stevearc/overseer.nvim',
  -- stylua: ignore
  keys = {
    { '<leader>wa', function() require('utils.overseer').open_floating_window() end, desc = 'Last automation in floating', },
  },
}
