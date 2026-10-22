---@class WkGroupSpec
---@field [1] string
---@field group string
---@field icon? string|table

---@alias SectionItem LazyKeysSpec|WkGroupSpec

---@type SectionItem[][]
local sections = {
  {
    { '<leader>w', group = 'window' },
    { '<leader>w<space>', '<c-w>p', desc = 'Last Window' },
    { '<leader>wD', '<cmd>windo diffthis<cr>', desc = 'Diff opened windows' },
  },
  {
    { '<leader>wd', group = 'delete' },
    { '<leader>wdd', '<c-w>c', desc = 'Delete current window' },
    { '<leader>wdo', '<c-w>o', desc = 'Delete other windows' },
  },
  {
    { '<leader>wm', group = 'move' },
    {
      '<leader>wmh',
      function()
        require('utils.window').swap_windows 'left'
      end,
      desc = 'Move current window left',
    },
    { '<leader>wmH', '<c-w>H', desc = 'Move current window to leftmost' },
    {
      '<leader>wmj',
      function()
        require('utils.window').swap_windows 'down'
      end,
      desc = 'Move current window down',
    },
    { '<leader>wmJ', '<c-w>J', desc = 'Move current window to bottom' },
    {
      '<leader>wmk',
      function()
        require('utils.window').swap_windows 'up'
      end,
      desc = 'Move current window up',
    },
    { '<leader>wmK', '<c-w>K', desc = 'Move current window to top' },
    {
      '<leader>wml',
      function()
        require('utils.window').swap_windows 'right'
      end,
      desc = 'Move current window right',
    },
    { '<leader>wmL', '<c-w>L', desc = 'Move current window to rightmost' },
  },
  {
    { '<leader>ws', group = 'split' },
    {
      '<leader>wsh',
      function()
        require('utils.window').split_window_left()
      end,
      desc = 'Split window left',
    },
    { '<leader>wsj', '<cmd>split<cr>', desc = 'Split window down' },
    {
      '<leader>wsk',
      function()
        require('utils.window').split_window_up()
      end,
      desc = 'Split window up',
    },
    { '<leader>wsl', '<cmd>vsplit<cr>', desc = 'Split window right' },
  },
  {
    { '<leader>wr', group = 'resize' },
    { '<leader>wre', '<c-w>=', desc = 'Equalize window sizes' },
    { '<leader>wrh', '<c-w>_', desc = 'Max out current window height' },
    { '<leader>wrw', '<c-w>|', desc = 'Max out current window width' },
  },
}

local specs, keys = {}, {}
for _, section in ipairs(sections) do
  for _, item in ipairs(section) do
    if item.group then
      table.insert(specs, item)
    else
      table.insert(keys, item)
    end
  end
end

return {
  'folke/which-key.nvim',
  opts_extend = { 'spec' },
  opts = {
    spec = specs,
  },
  keys = keys,
}
