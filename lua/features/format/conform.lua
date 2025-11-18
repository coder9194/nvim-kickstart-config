-- Lightweight yet powerful formatter plugin for Neovim
-- Autoformat
-- https://github.com/stevearc/conform.nvim

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if (not require('store.options').auto_format_enabled) or disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,

    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      javascript = { 'eslint_d', 'prettierd' },
      javascriptreact = { 'eslint_d', 'prettierd' },
      typescript = { 'eslint_d', 'prettierd' },
      typescriptreact = { 'eslint_d', 'prettierd' },
      json = { 'prettierd', stop_after_first = true },
      jsonc = { 'prettierd', stop_after_first = true },
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>Ff', function() require('conform').format { async = true } end, desc = 'Format buffer', },
  },
}
