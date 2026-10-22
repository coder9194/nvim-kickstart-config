local M = {}

-- Disable word wrap during a callback
function M.disable_word_wrap_during(callback)
  vim.cmd 'set nowrap'
  callback()
  vim.cmd 'tabprevious'
  vim.cmd 'set wrap'
  vim.cmd 'tabnext'
end

-- Check if the current tab is a diffview tab
function M.is_diffview_tab()
  local ok, lib = pcall(require, 'diffview.lib')
  return ok and lib.get_current_view() ~= nil
end

return M
