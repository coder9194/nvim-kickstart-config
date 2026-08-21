return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts_extend = {
      'ensure_installed',
    },
    opts = {
      ensure_installed = {
        'jdtls', -- Java LSP
        'lemminx', -- XML LSP for AndroidManifest.xml and layout files
      },
    },
  },
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
  },
}
