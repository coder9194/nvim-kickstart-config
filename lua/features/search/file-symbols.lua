return {
  -- Provides ways of navigating JSON document buffers.
  {
    'mogelbrod/vim-jsonpath',
    -- stylua: ignore
    keys = {
      { "<leader>sS", mode = "n", function() local json_path = vim.fn.input("Search JSON path: ") vim.cmd("JsonPath " .. json_path) end, desc = "Search JSON", },
    },
  },
}
