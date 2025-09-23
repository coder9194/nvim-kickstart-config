local M = {}

local registered_keymaps = {}

function M.clear_tab_keymaps()
  -- Clear all registered keymaps
  for _, keymap in ipairs(registered_keymaps) do
    pcall(vim.keymap.del, keymap.mode, keymap.lhs, { buffer = keymap.buffer })
  end

  registered_keymaps = {}
end

---@param tab_name string
function M.set_tab_keymaps(tab_name)
  local is_avante_ask_tab = require('utils.tab').is_tab_named(tab_name)

  if not is_avante_ask_tab then
    return
  end

  M.clear_tab_keymaps()

  vim.keymap.set('n', '<leader>tdd', function()
    vim.cmd 'AvanteToggle'
    vim.cmd 'tabclose'
  end, {
    buffer = 0,
    desc = 'Close ' .. tab_name,
  })

  table.insert(registered_keymaps, {
    mode = 'n',
    lhs = '<leader>tdd',
    buffer = vim.api.nvim_get_current_buf(),
  })
end

function M.is_avante_tab()
  local current_tab_name = require('utils.bufferline').get_current_tab_name()
  local is_avante_tab = current_tab_name and string.find(current_tab_name, 'Avante')

  return is_avante_tab
end

return M
