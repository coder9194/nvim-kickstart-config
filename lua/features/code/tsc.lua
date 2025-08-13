-- https://github.com/dmmulroy/tsc.nvim

return {
  "dmmulroy/tsc.nvim",
  config = true,
  opts = {
    use_trouble_qflist = true,
  },
  keys = {
    { "<leader>cdt", mode = "n", "<cmd>TSC<cr>", desc = "Workspace type diagnostic" },
  },
}
