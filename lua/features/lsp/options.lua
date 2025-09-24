vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Load notification options when Vim is started',
  callback = function()
    -- Disable LSP logging
    vim.lsp.set_log_level 'off'

    -- Enable LSP inlay hints
    vim.lsp.inlay_hint.enable(true)
  end,
})

return {} -- For file to be loaded without error
