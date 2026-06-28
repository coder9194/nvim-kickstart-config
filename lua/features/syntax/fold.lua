vim.opt.foldlevel = 99
vim.opt.foldenable = true

-- 2. Dynamically bind modern Treesitter folding to active buffers
vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  pattern = '*',
  callback = function()
    -- Set core local options to utilize native Lua treesitter expression routing
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    -- Force the buffer to recalculate fold boundaries instantly on read
    vim.cmd 'normal! zx'
  end,
})

return {}
