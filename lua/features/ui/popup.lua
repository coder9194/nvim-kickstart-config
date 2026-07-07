-- Hover popup (including LSP hover, signature help, and diagnostics)
vim.o.winborder = 'rounded'

return {
  -- Input popup
  {
    'folke/snacks.nvim',
    opts = {
      input = {
        enabled = true,
      },
    },
  },
}
