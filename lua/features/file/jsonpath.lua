-- Provides ways of navigating JSON document buffers.
-- https://github.com/mogelbrod/vim-jsonpath

return {
  'mogelbrod/vim-jsonpath',
  -- stylua: ignore
  keys = {
    { "<leader>fs", mode = "n", function() local json_path = vim.fn.input("Search JSON path: ") vim.cmd("JsonPath " .. json_path) end, desc = "Search JSON", },
  },
}
