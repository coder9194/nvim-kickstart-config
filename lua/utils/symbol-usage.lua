local M = {}

function M.refresh_all_symbol_usage()
  local ok, symbol_usage = pcall(require, 'symbol-usage')
  if not ok then
    return
  end

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    first_buffer_id = first_buffer_id or bufnr
    if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == '' then
      -- Execute within the specific buffer context
      vim.api.nvim_buf_call(bufnr, function()
        symbol_usage.refresh()
      end)
    end
  end
end

return M
