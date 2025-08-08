-- Blazing fast indentation style detection for Neovim written in Lua. The goal of this plugin is to automatically detect the indentation style used in a buffer and updating the buffer options accordingly. This mimics the "Guess Indentation Settings From Buffer" function built into Sublime Text.
-- Detect tabstop and shiftwidth automatically
-- https://github.com/NMAC427/guess-indent.nvim

return {
  'nmac427/guess-indent.nvim',
  config = true,
}
