-- A git commit browser
-- https://github.com/junegunn/gv.vim

function show_current_branch_log()
  local output = require('utils.nvim').get_command_output 'echo gitbranch#name()'
  vim.cmd('GV --first-parent ' .. output)
end

return {
  'junegunn/gv.vim',
  -- stylua: ignore
  keys = {
    { "<leader>ggc", mode = "n", show_current_branch_log, desc = "Git Log of Current Branch" },
  },
}
