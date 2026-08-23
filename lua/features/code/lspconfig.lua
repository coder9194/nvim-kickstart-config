return {
  'neovim/nvim-lspconfig',
  -- stylua: ignore
  keys = {
    { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename Variable' },
  },
}
