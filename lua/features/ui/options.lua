vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Load options when Vim is started',
  callback = function()
    vim.o.relativenumber = true
  end,
})

return {}
