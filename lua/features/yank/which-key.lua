return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { '<leader>y', group = 'Yank' },
      { '<leader>yf', group = 'file' },
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>yff', desc = 'Copy file full path', function() local file_full_path = require('utils.file').get_full_path() require('utils.nvim').copy_to_clipboard(file_full_path) end, },
    { '<leader>yfr', desc = 'Copy file relative path', function() local file_relative_path = require('utils.file').get_relative_path() require('utils.nvim').copy_to_clipboard(file_relative_path) end, },
    { '<leader>yft', desc = 'Copy filename', function() local file_filename = require('utils.file').get_filename() require('utils.nvim').copy_to_clipboard(file_filename) end, },
  },
}
