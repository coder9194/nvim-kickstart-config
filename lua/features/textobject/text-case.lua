-- An all in one plugin for converting text case in Neovim. It converts a piece of text to an indicated string case and also is capable of bulk replacing texts without changing cases
-- https://github.com/johmsalas/text-case.nvim

return {
  'johmsalas/text-case.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = true,
  keys = {
    { mode = { 'n', 'v' }, 'ga', '<cmd>TextCaseOpenTelescope<cr>', desc = 'Change text case' },
  },
}
