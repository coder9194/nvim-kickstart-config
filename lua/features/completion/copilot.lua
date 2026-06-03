-- Code suggestion powered by GitHub Copilot (Keep for Copilot Authentication)
-- https://github.com/zbirenbaum/copilot.lua
return {
  'zbirenbaum/copilot.lua',
  enabled = false,
  cmd = 'Copilot',
  event = { 'InsertEnter' },
  config = function()
    require('copilot').setup {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          accept = '<M-Enter>',
          accept_word = '<M-l>',
          accept_line = '<M-;>',
          next = '<M-j>',
          prev = '<M-k>',
          dismiss = '<C-]>',
        },
      },
    }
  end,
}
