-- https://github.com/rachartier/tiny-glimmer.nvim
-- A Neovim plugin that adds smooth, customizable animations to text operations like yank, paste, search, undo/redo, and more.
return {
  'rachartier/tiny-glimmer.nvim',
  event = 'VeryLazy',
  priority = 10, -- Low priority to catch other plugins' keybindings
  opts = {
    transparency_color = '#312c2b',
    overwrite = {
      search = {
        enabled = true,
      },
      undo = {
        enabled = true,
      },
      redo = {
        enabled = true,
      },
    },
  },
}
