-- https://github.com/supermaven-inc/supermaven-nvim
return {
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {
        keymaps = {
          accept_suggestion = '<M-Enter>',
          clear_suggestion = '<M-h>',
          accept_word = '<M-l>',
        },
      }
    end,
  },
}
