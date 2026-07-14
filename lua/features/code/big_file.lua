return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    -- Automatically prevents things like LSP and Treesitter attaching to the buffer of big file.
    bigfile = {
      enabled = true,
    },
  },
}
