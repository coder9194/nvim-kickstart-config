return {
  'neovim/nvim-lspconfig',
  -- stylua: ignore
  keys = {
    { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename Variable' },
    { '<leader>ca', mode = { 'n', 'v' }, vim.lsp.buf.code_action, desc = 'Code Actions' },
    { '<leader>cA', function() vim.lsp.buf.code_action { context = { diagnostics = {}, only = { 'source' } } } end, desc = 'Source Actions', },
  },
}
