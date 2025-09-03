-- Portable package manager for LSP, DAP, linters & formatters
-- https://github.com/mason-org/mason.nvim

return {
  'mason-org/mason.nvim',
  opts = {
    ui = {
      border = 'rounded',
    },
  },
  keys = {
    { '<leader>lm', mode = 'n', '<cmd>Mason<cr>', desc = 'LSP Manager' },
  },
}
