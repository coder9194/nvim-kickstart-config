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
  :map '<leader>SF'

return {}
