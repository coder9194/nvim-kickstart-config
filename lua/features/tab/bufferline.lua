return {
  'akinsho/bufferline.nvim',
  -- stylua: ignore
  keys = {
    { "<leader>tr", mode = "n", function() local new_tab_name = vim.fn.input("Rename tab: ") vim.cmd("BufferLineTabRename " .. new_tab_name) end, desc = "Rename tab", },
  },
}
