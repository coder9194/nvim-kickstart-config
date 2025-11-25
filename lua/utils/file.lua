local M = {}

function M.get_full_path()
  return vim.fn.expand '%:p'
end

function M.get_relative_path()
  return vim.fn.expand '%'
end

function M.get_filename()
  return vim.fn.expand '%:t'
end

return M
