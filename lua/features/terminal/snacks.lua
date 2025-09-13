return {
  'folke/snacks.nvim',
  opts = {
    terminal = {
      enabled = true,
    },
  },
  keys = {
    {
      '<leader>TT',
      function()
        require('snacks.terminal').toggle()
      end,
      desc = 'Toggle Terminal',
    },
  },
}
