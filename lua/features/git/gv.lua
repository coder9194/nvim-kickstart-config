-- A git commit browser
-- https://github.com/junegunn/gv.vim

return {
  'junegunn/gv.vim',
  -- stylua: ignore
  keys = {
    { "<leader>ggc", mode = "n", function() require("utils.gv-vim").show_current_branch_log() end, desc = "Git Log of Current Branch" },
  },
}
