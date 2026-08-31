local M = {}

function M.search_result()
  -- Only execute tracking logic if search highlighting is currently active
  if vim.v.hlsearch == 0 then
    return ''
  end

  -- Safely call Neovim's internal search calculator
  local res = vim.fn.searchcount { maxcount = 999, timeout = 500 }

  -- If there are no occurrences or formatting properties are empty, return blank
  if res.total == 0 then
    return ''
  end

  -- Format output string exactly as [current/total]
  return string.format(' [%d/%d]', res.current, res.total)
end

return M
