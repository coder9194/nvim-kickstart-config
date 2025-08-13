-- Portable package manager for LSP, DAP, linters & formatters
-- https://github.com/mason-org/mason.nvim

return {
  'mason-org/mason.nvim',
  opts = {
    ui = {
      border = 'rounded',
    },
    ensure_installed = {
      -- General
      'cspell', -- Spell checking
      'shfmt', -- Bash
      -- Web
      'css-lsp',
      'css-variables-language-server',
      'cssmodules-language-server',
      'stylelint-lsp', -- CSS linting
      'some-sass-language-server',
      'json-lsp',
      'vue-language-server',
      'prettier', -- Formatter
      'eslint-lsp',
      -- Lua
      'lua-language-server',
      'stylua', -- Formatter
    },
  },
  keys = {
    { '<leader>lm', mode = 'n', '<cmd>Mason<cr>', desc = 'LSP Manager' },
  },
}
