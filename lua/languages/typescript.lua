return {
  -- LSP Server
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        tsc = {
          cmd = { 'tsc', '--lsp', '--stdio' }, -- Explicitly invoke global tsc, skipping project node_modules
          on_attach = function(client, bufnr)
            if client.supports_method 'textDocument/codeLens' then
              vim.lsp.codelens.refresh { bufnr = bufnr }

              -- Refresh CodeLens when leaving insert mode or holding cursor
              vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'CursorHold' }, {
                buffer = bufnr,
                callback = function()
                  vim.lsp.codelens.refresh { bufnr = bufnr }
                end,
              })
            end
          end,
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = {
                  enabled = 'all',
                },
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = false },
              },
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
              implementationsCodeLens = {
                enabled = true,
              },
            },
          },
        },
      },
    },
  },
  -- https://github.com/dmmulroy/tsc.nvim
  {
    'dmmulroy/tsc.nvim',
    config = true,
    opts = {
      use_trouble_qflist = true,
    },
    keys = {
      { '<leader>cdt', mode = 'n', '<cmd>TSC<cr>', desc = 'Workspace type diagnostic' },
    },
  },
}
