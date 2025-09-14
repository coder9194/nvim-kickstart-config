return {
  'neovim/nvim-lspconfig',
  keys = {
    { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename Variable' },
    { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code Actions' },
  },
}
