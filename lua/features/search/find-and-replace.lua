return {
  {
    'MagicDuck/grug-far.nvim',
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
      vim.api.nvim_create_user_command('GrugFarFloat', function()
        local width = math.floor(vim.o.columns * 0.85)
        local height = math.floor(vim.o.lines * 0.85)
        local col = math.floor((vim.o.columns - width) / 2)
        local row = math.floor((vim.o.lines - height) / 2)

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_open_win(buf, true, {
          relative = 'editor',
          width = width,
          height = height,
          row = row,
          col = col,
          style = 'minimal',
          border = 'rounded',
        })
      end, {})

      require('grug-far').setup {
        windowCreationCommand = 'GrugFarFloat',
      }
    end,
    -- stylua: ignore
    keys = { { '<leader>sr', function() require('grug-far').open {} end, desc = 'Search and Replace', }, },
  },
}
