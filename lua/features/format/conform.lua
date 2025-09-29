-- Lightweight yet powerful formatter plugin for Neovim
-- Autoformat
-- https://github.com/stevearc/conform.nvim

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})

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
      if disable_filetypes[vim.bo[bufnr].filetype] then
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
      javascript = { 'prettier', stop_after_first = true },
      javascriptreact = { 'prettier', stop_after_first = true },
      typescript = { 'prettier', stop_after_first = true },
      typescriptreact = { 'prettier', stop_after_first = true },
      json = { 'prettier', stop_after_first = true },
      jsonc = { 'prettier', stop_after_first = true },
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>Ff', function() require('conform').format { async = true } end, desc = 'Format buffer', },
  },
}
