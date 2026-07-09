return {
  'folke/which-key.nvim',
  -- Allow part of the options passed to the opts table should be treated as a list that is extended rather than replaced completely
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { '<leader>t', group = 'Tab' },
      { '<leader>td', group = 'Delete' },
      { '<leader>tl', group = 'Layout' },
      { '<leader>tm', group = 'Move' },
      { '<leader>tn', group = 'New' },
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>tw', '<cmd>windo update<cr>', desc = 'Write all changes in current tab' },
    { '<leader>t<space>', 'g<tab>', desc = 'Last active tab' },
    { '<leader>tdd', '<cmd>tabclose<cr>', desc = 'Close current tab' },
    { '<leader>tdl', '<cmd>.+1,$tabdo :tabclose<cr>', desc = 'Close tabs to the right' },
    { '<leader>tdo', '<cmd>tabonly<cr>', desc = 'Close other tabs' },
    { '<leader>tdt', function() local target_tab_id = vim.fn.input 'Target tab ID to delete: ' vim.cmd('tabclose' .. target_tab_id) end, desc = 'Close target tab by ID', },
    { '<leader>tmh', '<cmd>tabm -1<cr>', desc = 'Move tab to left' },
    { '<leader>tml', '<cmd>tabm +1<cr>', desc = 'Move tab to right' },
    { '<leader>tnh', '<cmd>-tabnew<cr>', desc = 'New tab to left' },
    { '<leader>tnH', '<cmd>0tabnew<cr>', desc = 'New tab to start of tab bar' },
    { '<leader>tnl', '<cmd>tabnew<cr>', desc = 'New tab to right' },
    { '<leader>tnL', '<cmd>$tabnew<cr>', desc = 'New tab to end of tab bar' },
    { '<leader>tnt', function() local target_tab_id = vim.fn.input 'Target tab ID of new tab after: ' vim.cmd(target_tab_id .. 'tabnew') end, desc = 'New tab after tab ID', },
  },
}
