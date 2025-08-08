return {
  'nvim-neo-tree/neo-tree.nvim',
  -- stylua: ignore
  keys = {
    { mode = 'n', '<leader>ge', function() require('neo-tree.command').execute { source = 'git_status', toggle = true, position = 'float' } end, desc = 'Git explorer', },
  },
}
