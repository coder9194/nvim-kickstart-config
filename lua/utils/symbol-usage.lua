local M = {}

-- Refresh symbol usages in active (displayed) buffers
function M.refresh_active_symbol_usage(delay_ms)
  delay_ms = delay_ms or 50 -- Default 50ms interval between buffer refreshes

  local ok, symbol_usage = pcall(require, 'symbol-usage')
  if not ok then
    return
  end

  local refreshed = {}
  local target_buffers = {}

  -- 1. Collect unique valid target buffers
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufnr = vim.api.nvim_win_get_buf(winid)
    if not refreshed[bufnr] and vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == '' then
      refreshed[bufnr] = true
      table.insert(target_buffers, bufnr)
    end
  end

  -- 2. Schedule staggered execution per buffer
  for i, bufnr in ipairs(target_buffers) do
    local timeout = (i - 1) * delay_ms
    vim.defer_fn(function()
      -- Re-verify buffer validity in case it was wiped/closed during the delay window
      if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
        vim.api.nvim_buf_call(bufnr, function()
          symbol_usage.refresh()
        end)
      end
    end, timeout)
  end
end

return M
