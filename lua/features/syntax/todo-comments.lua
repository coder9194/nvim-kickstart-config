-- todo-comments is a lua plugin for Neovim >= 0.8.0 to highlight and search for todo comments like TODO, HACK, BUG in your code base.
-- Highlight todo, notes, etc in comments
-- https://github.com/folke/todo-comments.nvim

return {
  'folke/todo-comments.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    signs = false,
    keywords = {
      DEV = { icon = ' ', color = 'info' },
    },
    merge_keywords = true,
  },
  -- stylua: ignore
  keys = {
    ---@diagnostic disable-next-line: undefined-field
    { '<leader>sd', function() require('snacks').picker.todo_comments { keywords = { 'DEV' } } end, desc = 'Dev', },
    ---@diagnostic disable-next-line: undefined-field
    { '<leader>st', function() require('snacks').picker.todo_comments { keywords = { 'TODO' } } end, desc = 'Todo', },
    ---@diagnostic disable-next-line: undefined-field
    { '<leader>sf', function() require('snacks').picker.todo_comments { keywords = { 'FIX' } } end, desc = 'Fixme', },
  },
}
