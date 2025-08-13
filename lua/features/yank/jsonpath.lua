-- Plugin containing a function to return a path to access the value under the cursor by using treesitter. It may help you understand how to access even deeply nested values in JSON files.
-- https://github.com/phelipetls/jsonpath.nvim

return {
  'phelipetls/jsonpath.nvim',
  -- stylua: ignore
  keys = {
    { "<leader>yj", mode = "n", function() local json_path = require("jsonpath").get():gsub("^%.", "") vim.fn.setreg("+", json_path) end, desc = "Json path", },
  },
}
