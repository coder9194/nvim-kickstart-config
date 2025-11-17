-- TypeScript integration NeoVim deserves
-- https://github.com/pmizio/typescript-tools.nvim
return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    settings = {
      expose_as_code_action = 'all',
      tsserver_file_preferences = {
        -- NOTE: ref: https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3439
        includeInlayParameterNameHints = 'all',
        includeCompletionsForModuleExports = true,
        quotePreference = 'auto',
      },
      tsserver_format_options = {
        -- NOTE: ref: https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3418
        allowIncompleteCompletions = false,
        allowRenameOfImportPath = false,
      },
      code_lens = 'all',
    },
  },
}
