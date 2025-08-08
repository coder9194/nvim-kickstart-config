-- Bindings for Git
-- https://github.com/tpope/vim-fugitive

return {
  'tpope/vim-fugitive',
  lazy = false,
  -- stylua: ignore
  keys = {
    { '<leader>gbf', mode = 'n', '<cmd>Git blame<cr>', desc = 'Blame File' },
  },
}
