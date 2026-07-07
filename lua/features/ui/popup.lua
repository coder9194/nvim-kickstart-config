-- Hover popup (including LSP hover, signature help, and diagnostics)
vim.o.winborder = 'rounded'

return {
  -- Input popup
  {
    {
      'folke/snacks.nvim',
      opts = {
        input = {
          enabled = true,
        },
      },
    },
    {
      'folke/noice.nvim',
      opts_extend = {
        'popupmenu',
      },
      opts = {
        popupmenu = {
          enabled = false,
        },
      },
    },
  },

  -- Hover
  {
    'folke/noice.nvim',
    opts_extend = {
      'lsp.hover',
    },
    opts = {
      lsp = {
        hover = {
          enabled = false,
        },
      },
    },
  },

  -- Cmdline
  {
    'folke/noice.nvim',
    opts_extend = {
      'cmdline',
      'presets',
    },
    opts = {
      cmdline = {
        enabled = true,
      },
      presets = {
        command_palette = true,
      },
    },
  },
}
