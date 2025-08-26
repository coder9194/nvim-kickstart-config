vim.o.cmdheight = 0 -- Hide command line when not being used

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
