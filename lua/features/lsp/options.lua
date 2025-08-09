-- Disable LSP logging
vim.lsp.set_log_level 'off'

-- Enable LSP inlay hints
vim.lsp.inlay_hint.enable(true)

return {} -- For file to be loaded without error
