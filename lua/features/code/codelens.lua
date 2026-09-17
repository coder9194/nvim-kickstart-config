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
        local win = vim.api.nvim_get_current_win()
        local is_normal_window = vim.api.nvim_win_get_config(win).relative == ''

        if is_normal_window then
          require('utils.symbol-usage').refresh_active_symbol_usage()
        end
      end, 100)

      vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
        callback = function(args)
          local win = vim.api.nvim_get_current_win()
          local is_floating_window = vim.api.nvim_win_get_config(win).relative ~= ''
          local is_non_normal_buffer = vim.bo[args.buf].buftype ~= ''

          if is_floating_window or is_non_normal_buffer then
            return
          end

          require('utils.symbol-usage').refresh_active_symbol_usage()
        end,
      })
    end,
  },
}
