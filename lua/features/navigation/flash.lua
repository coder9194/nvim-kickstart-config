-- flash.nvim lets you navigate your code with search labels,
-- enhanced character motions, and Treesitter integration

return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    label = {
      uppercase = false,
    },
    modes = {
      char = {
        jump_labels = true,
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  },
}
