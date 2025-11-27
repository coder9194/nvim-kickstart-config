-- NOTE: https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
-- all `properties` are under `vtsls.settings`

local javascript_typescript_settings = {
  tsserver = {
    maxTsServerMemory = 4096,
  },
  inlayHints = {
    parameterNames = {
      enabled = 'all',
    },
  },
  updateImportsOnFileMove = { enabled = 'always' },
  referencesCodeLens = {
    enabled = true,
    showOnAllFunctions = true,
  },
  implementationsCodeLens = {
    enabled = true,
    showOnInterfaceMethods = true,
  },
  preferences = {
    includePackageJsonAutoImports = true,
  },
}

return {
  on_attach = function(client, bufnr)
    require('features.lsp.configs.utils').use_codelens(client, bufnr)
  end,
  experimental = {
    completion = {
      enableServerSideFuzzyMatch = true,
      entriesLimit = 100,
    },
  },
  flags = {
    allow_incremental_sync = true,
  },
  settings = {
    typescript = javascript_typescript_settings,
    javascript = javascript_typescript_settings,
  },
}
