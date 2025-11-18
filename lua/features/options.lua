require('snacks').toggle
  .new({
    name = 'Auto Format (Global)',
    get = function()
      return require('store.options').auto_format_enabled == true
    end,
    set = function(state)
      require('store.options').auto_format_enabled = state
    end,
  })
  :map '<leader>of'

return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { '<leader>o', group = 'options' },
    },
  },
}
