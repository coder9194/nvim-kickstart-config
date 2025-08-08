-- Flog is a fast, beautiful, and powerful git branch viewer for Vim.
-- https://github.com/rbong/vim-flog

return {
  'rbong/vim-flog',
  dependencies = {
    'tpope/vim-fugitive',
  },
  -- stylua: ignore
  keys = {
    { '<leader>gga', mode = 'n', '<cmd>Flog -all<cr>', desc = 'Git Log of All Branches' },
  },
}
