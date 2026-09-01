return {
  -- Bridge to add custom code actions
  {
    'nvimtools/none-ls.nvim',
    opts = function()
      local null_ls = require 'null-ls'
      local make_builtin = require 'null-ls.helpers.make_builtin'

      null_ls.setup {
        sources = {
          make_builtin {
            name = 'custom_ts_refactors',
            method = null_ls.methods.CODE_ACTION,
            filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
            generator = {
              fn = function(params)
                local actions = {}
                local bufnr = params.bufnr
                local node = vim.treesitter.get_node { bufnr = bufnr }
                if not node then
                  return
                end

                table.insert(actions, require 'features.lsp.code_actions.inline_variable'(node, bufnr))
                table.insert(actions, require 'features.lsp.code_actions.extract_variable'(bufnr))
                table.insert(actions, require 'features.lsp.code_actions.extract_function'(bufnr))
                table.insert(actions, require 'features.lsp.code_actions.extract_function_to_file'(bufnr))
                table.insert(actions, require 'features.lsp.code_actions.inline_function'(node, bufnr))

                return actions
              end,
            },
          },
        },
      }
    end,
  },
  {
    'folke/which-key.nvim',
    keys = {
      { '<leader>ca', mode = { 'n', 'v' }, require('features.lsp.utils.code_actions').run_code_action, desc = 'Code Actions' },
      {
        '<leader>cA',
        function()
          vim.lsp.buf.code_action { context = { diagnostics = {}, only = { 'source' } } }
        end,
        desc = 'Source Actions',
      },
    },
  },
}
