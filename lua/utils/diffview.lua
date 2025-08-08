local M = {}

-- Disable word wrap during a callback
function M.disable_word_wrap_during(callback)
  vim.cmd 'set nowrap'
  callback()
  vim.cmd 'tabprevious'
  vim.cmd 'set wrap'
  vim.cmd 'tabnext'
end

return M
