-- An all in one plugin for converting text case in Neovim. It converts a piece of text to an indicated string case and also is capable of bulk replacing texts without changing cases
-- https://github.com/johmsalas/text-case.nvim

return {
  'johmsalas/text-case.nvim',
  dependencies = {
    {
      'nvim-telescope/telescope.nvim',
      opts = {
        defaults = {
          layout_config = {
            horizontal = {
              prompt_position = 'top',
            },
            vertical = {
              prompt_position = 'top',
            },
          },
        },
      },
    },
  },
  config = function()
    require('textcase').setup {}
    require('telescope').load_extension 'textcase'
  end,
  keys = {
    'ga', -- Default invocation prefix
    { 'ga.', '<cmd>TextCaseOpenTelescope<CR>', mode = { 'n', 'x' }, desc = 'Telescope' },
  },
  cmd = {
    -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
    'Subs',
    'TextCaseOpenTelescope',
    'TextCaseOpenTelescopeQuickChange',
    'TextCaseOpenTelescopeLSPChange',
    'TextCaseStartReplacingCommand',
  },
  lazy = false,
}
