-- Flog is a fast, beautiful, and powerful git branch viewer for Vim.
-- https://github.com/rbong/vim-flog

return {
  {
    'rbong/vim-flog',
    dependencies = {
      'tpope/vim-fugitive',
    },
    keys = {
      { '<leader>gga', mode = 'n', '<cmd>Flog -all<cr>', desc = 'Git Log of All Branches' },
      {
        '<leader>ggb',
        function()
          vim.ui.input({
            prompt = 'Target branch: ',
            completion = 'customlist,v:lua.flog_branch_completion',
          }, function(branch)
            if branch and #branch > 0 then
              -- Pass the branch target directly to Flog
              vim.cmd('Flog -- ' .. vim.fn.fnameescape(branch))
            end
          end)
        end,
        desc = 'Git Log of Target Branch',
        mode = 'n',
      },
      {
        '<leader>ggc',
        function()
          -- Get the current branch using fugitive / vim-gitbranch
          local branch = vim.fn['gitbranch#name']()
          if branch and #branch > 0 then
            vim.cmd('Flog -raw-args=--first-parent -- ' .. vim.fn.fnameescape(branch))
          else
            vim.cmd 'Flog -raw-args=--first-parent'
          end
        end,
        desc = 'Git Log of Current Branch (First Parent)',
        mode = 'n',
      },
    },
  },
}
