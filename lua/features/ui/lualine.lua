vim.o.cmdheight = 0 -- Hide command line when not being used

-- TODO: find a way to remove this workaround
vim.api.nvim_create_autocmd('RecordingEnter', {
  desc = 'Show command line when recording macros',
  callback = function()
    vim.opt.cmdheight = 1
  end,
})
vim.api.nvim_create_autocmd('RecordingLeave', {
  desc = 'Hide command line when not recording macros',
  callback = function()
    vim.opt.cmdheight = 0
  end,
})

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    options = {
      globalstatus = true, -- enable global single statusline at neovim bottom
    },
  },
}
