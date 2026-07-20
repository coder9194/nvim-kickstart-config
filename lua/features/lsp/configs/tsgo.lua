-- NOTE: https://github.com/sublimelsp/LSP-tsgo/blob/main/LSP-tsgo.sublime-settings
return {
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
}
