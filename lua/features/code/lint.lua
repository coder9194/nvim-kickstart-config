vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged' }, {
  callback = function()
    require('lint').try_lint()
  end,
})

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function()
    require('lint').try_lint 'cspell'
  end,
})

-- An asynchronous linter plugin for Neovim (>= 0.9.5) complementary to the built-in Language Server Protocol support.
-- https://github.com/mfussenegger/nvim-lint
return {
  'mfussenegger/nvim-lint',
  config = function()
    require('lint').linters_by_ft = {
      javascript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescript = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
    }
  end,
}
