vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Load options when Vim is started',
  callback = function()
    vim.opt.number = true
    vim.opt.relativenumber = true
  end,
})

return {}
