vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Load notification options when Vim is started',
  callback = function()
    -- Suppress write message
    vim.o.shortmess = vim.o.shortmess .. 'W'
  end,
})

return {} -- For file to be loaded without error
