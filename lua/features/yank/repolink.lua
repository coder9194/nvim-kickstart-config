-- Link a file or a line range in a file to some URL that you can use to share with your colleagues.
-- https://github.com/9seconds/repolink.nvim-lua

return {
  "9seconds/repolink.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = {
    "RepoLink",
  },
  config = function()
    require("repolink").setup({
      -- your configuration goes here.
      -- keep empty object if you are fine with defaults
      url_builders = {
        ["JerryLam94@bitbucket.org"] = require("repolink").url_builder_for_bitbucket("https://bitbucket.org"),
      },
    })
  end,
  keys = {
    { "<leader>yr", mode = "n", "<cmd>RepoLink!<cr>", desc = "Repo Link" },
    { "<leader>yr", mode = "v", "<cmd>'<,'>RepoLink!<cr>", desc = "Repo Link" },
  },
}
