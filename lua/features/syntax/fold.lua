vim.opt.foldenable = true -- Enable folding

-- Everything stays open and visible by default.
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterFolding', { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local line_count = vim.api.nvim_buf_line_count(bufnr)

    -- Bypass Treesitter folding on huge files to prevent normal mode lag
    if line_count > 5000 then
      return
    end

    -- Set window-local folding options safely
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})

return {}
