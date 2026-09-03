return {
  -- Plugins for automatic refresh codelens
  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach', -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    config = function()
      require('symbol-usage').setup {
        references = {
          enabled = true,
          include_declaration = true,
        },
        definition = { enabled = true },
        implementation = { enabled = true },
        -- Try setting symbol_request_pos to 'start' globally or per-filetype
        disable = {
          lsp = { 'copilot', 'null-ls', 'eslint', 'efm' },
          filetypes = { 'markdown', 'text', 'help' },
        },
      }

      vim.defer_fn(function()
        require('utils.symbol-usage').refresh_active_symbol_usage()
      end, 100)

      vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
        callback = function(args)
          require('utils.symbol-usage').refresh_active_symbol_usage()
        end,
      })
    end,
  },
}
