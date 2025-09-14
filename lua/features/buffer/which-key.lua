return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { '<leader>b', group = 'Buffer' },
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>bD', function() require('utils.buffer').delete_invisible_buffers() end, desc = 'Delete invisible buffers', },
    { '<leader>bp', function() require('utils.window').set_current_window_buffer(vim.g.custom_buffer_yank_id) end, desc = 'Paste current buffer by yanked buffer', },
    { '<leader>br', function() vim.cmd 'e!' vim.lsp.inlay_hint.enable() end, desc = 'Buffer reload', },
    { '<leader>bt', function() local position_in_line, line_number = require('utils.nvim').get_cursor_position() vim.cmd 'tabe %' require('utils.nvim').set_cursor_position(position_in_line, line_number) end, desc = 'Open current buffer into new tab', },
    { '<leader>bw', '<cmd>w<cr>', desc = 'Write all changes in current buffer' },
    { '<leader>by', function() vim.g.custom_buffer_yank_id = require('utils.buffer').get_current_buffer_id() end, desc = 'Yank current buffer', },
    { '<leader>b<space>', '<cmd>e #<cr>', desc = 'Last active buffer' },
  },
}
