-- Deep buffer integration for Git
-- Adds git related signs to the gutter, as well as utilities for managing changes
-- https://github.com/lewis6991/gitsigns.nvim

local show_blame_line_popup_and_focus = function()
  -- 1. Preserve Neovim's original window creation function
  local original_open_win = vim.api.nvim_open_win

  -- 2. Intercept the function to force focus
  vim.api.nvim_open_win = function(buf, enter, config)
    -- Force the 'enter' argument to true so the cursor jumps inside immediately
    local win = original_open_win(buf, true, config)

    -- Instantly self-heal and restore the original Neovim function
    vim.api.nvim_open_win = original_open_win
    return win
  end

  require('gitsigns.actions').blame_line { full = true }
end

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
    { '<leader>gbl', mode = 'n', show_blame_line_popup_and_focus, desc = 'Blame Line' },
    { '<leader>ghs', mode = 'n', function() require('gitsigns.actions').stage_hunk() end, desc = 'Stage/Unstage hunk' },
    { '<leader>ghS', mode = 'n', function() require('gitsigns.actions').stage_buffer() end, desc = 'Stage file hunks' },
    { '<leader>ghr', mode = 'n', function() require('gitsigns.actions').reset_hunk() end, desc = 'Reset hunk' },
    { '<leader>ghR', mode = 'n', function() require('gitsigns.actions').reset_buffer() end, desc = 'Reset file hunks' },
    { '<leader>ghs', mode = 'v', function() require('gitsigns.actions').stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, desc = 'Stage hunk(s)', },
    { '<leader>ghr', mode = 'v', function() require('gitsigns.actions').reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, desc = 'Reset hunk(s)', },
  },
}
