-- Deep buffer integration for Git
-- Adds git related signs to the gutter, as well as utilities for managing changes
-- https://github.com/lewis6991/gitsigns.nvim

return {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
  },
  -- stylua: ignore
  keys = {
---@diagnostic disable-next-line: param-type-mismatch
    { 'Hh', function() require('gitsigns').nav_hunk 'prev' end, desc = 'Preview hunk', },
---@diagnostic disable-next-line: param-type-mismatch
    { 'Lh', function() require('gitsigns').nav_hunk 'next' end, desc = 'Next hunk', },
    { '<leader>gbl', mode = 'n', function() require('gitsigns.actions').blame_line() end, desc = 'Blame Line' },
    { '<leader>ghs', mode = 'n', function() require('gitsigns.actions').stage_hunk() end, desc = 'Stage/Unstage hunk' },
    { '<leader>ghS', mode = 'n', function() require('gitsigns.actions').stage_buffer() end, desc = 'Stage file hunks' },
    { '<leader>ghr', mode = 'n', function() require('gitsigns.actions').reset_hunk() end, desc = 'Reset hunk' },
    { '<leader>ghR', mode = 'n', function() require('gitsigns.actions').reset_buffer() end, desc = 'Reset file hunks' },
    { '<leader>ghu', mode = 'n', function() require('gitsigns.actions').undo_stage_hunk() end, desc = 'Undo last staged hunk' },
    { '<leader>ghs', mode = 'v', function() require('gitsigns.actions').stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, desc = 'Stage hunk(s)', },
    { '<leader>ghr', mode = 'v', function() require('gitsigns.actions').reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, desc = 'Reset hunk(s)', },
  },
}
