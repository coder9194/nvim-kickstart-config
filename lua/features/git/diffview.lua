-- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
-- https://github.com/sindrets/diffview.nvim

return {
  'sindrets/diffview.nvim',
  dependencies = {
    'akinsho/bufferline.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    view = {
      merge_tool = {
        layout = 'diff3_horizontal',
      },
    },
    -- stylua: ignore
    keymaps = {
      file_panel = {
        { "n", "-", false },
        { "n", "s", false },
        { "n", "S", function() require("diffview.actions").toggle_stage_entry() end, { desc = "Stage / unstage the selected entry" }, },
      },
      view = {
        { "n", "<leader>co", false },
        { "n", "<leader>ct", false },
        { "n", "<leader>cb", false },
        { "n", "<leader>ca", false },
        { "n", "dx", false },
        { "n", "<leader>cO", false },
        { "n", "<leader>cT", false },
        { "n", "<leader>cB", false },
        { "n", "<leader>cA", false },
        { "n", "dX", false },
        { "n", "<leader>b", false },

        { "n", "Hx", function() require("diffview.actions").prev_conflict() end, { desc = "Previous conflict" }, },
        { "n", "Lx", function() require("diffview.actions").next_conflict() end, { desc = "Next conflict" }, },
        { "n", "<leader>gch", function() require("diffview.actions").conflict_choose("ours")() end, { desc = "Choose ours conflict" }, },
        { "n", "<leader>gcl", function() require("diffview.actions").conflict_choose("theirs")() end, { desc = "Choose theirs conflict" }, },
        { "n", "<leader>gcb", function() require("diffview.actions").conflict_choose("all")() end, { desc = "Choose both conflicts" }, },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>gdb', mode = 'n', function() require('utils.diffview').disable_word_wrap_during(function() local target_branch = vim.fn.input 'Target branch: ' if target_branch == '' then return end vim.cmd('DiffviewOpen ' .. target_branch .. '...HEAD') vim.cmd 'BufferLineTabRename Branch Diff' end) end, desc = 'Branch diff', },
    { '<leader>gdB', mode = 'n', function() require('utils.diffview').disable_word_wrap_during(function() local target_branch = vim.fn.input 'Target branch: ' if target_branch == '' then return end vim.cmd('DiffviewOpen ' .. target_branch .. '...HEAD --imply-local') vim.cmd 'BufferLineTabRename Branch Diff (Local)' end) end, desc = 'Branch diff with local file (LSP available)', },
    { '<leader>gdc', mode = 'n', function() require('utils.diffview').disable_word_wrap_during(function() vim.cmd 'DiffviewOpen' vim.cmd 'BufferLineTabRename Changes Diff' end) end, desc = 'Changes diff / Merge tool', },
    { '<leader>gdf', mode = 'n', function() require('utils.diffview').disable_word_wrap_during(function() vim.cmd 'DiffviewFileHistory %' vim.cmd 'BufferLineTabRename File History' end) end, desc = 'File History', },
    { '<leader>gdl', mode = 'n', function() local _, current_line_number = require('utils.nvim').get_cursor_position() local current_file_path = require('utils.buffer').get_current_buffer_file_path() vim.cmd('DiffviewFileHistory -L' .. current_line_number .. ':' .. current_file_path) end, desc = 'Line History', },
    { '<leader>gdt', mode = 'n', function() require('utils.diffview').disable_word_wrap_during(function() local target_commit = vim.fn.input 'Target commit: ' if target_commit == '' then return end vim.cmd('DiffviewOpen ' .. target_commit .. '^!') vim.cmd('BufferLineTabRename ' .. string.sub(target_commit, 1, 8) .. ' Diff') end) end, desc = 'Commit View', },
  },
}
