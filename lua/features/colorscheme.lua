-- You can easily change to a different colorscheme.
-- Change the name of the colorscheme plugin below, and then
-- change the command in the config to whatever the name of that colorscheme is.
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.

-- This color scheme is based on Monokai Pro, the contrast is adjusted to be a bit lower while keeping the colors vivid enough.
-- https://github.com/sainnhe/sonokai

return {
  'sainnhe/sonokai',
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    -- Options should be placed before `vim.cmd.colorscheme 'sonokai'`.
    vim.g.sonokai_style = 'espresso'
    vim.g.sonokai_better_performance = true
    vim.g.sonokai_enable_italic = true
    vim.cmd.colorscheme 'sonokai'
  end,
}
