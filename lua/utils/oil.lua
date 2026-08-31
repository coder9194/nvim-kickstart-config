local M = {}

-- Go back to parent directory within project root
function M.go_back_within_root()
  local oil = require 'oil'

  local current_dir = oil.get_current_dir()
  if not current_dir then
    return
  end

  -- Normalize current directory path
  current_dir = vim.fs.normalize(current_dir):gsub('/+$', '')

  -- Detect project root marker
  local root = vim.fs.root(current_dir, { '.git', 'package.json', 'Makefile', 'pnpm-workspace.yaml' }) or vim.fn.getcwd()
  root = vim.fs.normalize(root):gsub('/+$', '')

  -- If called from a standard file buffer, open oil at current_dir
  if vim.bo.filetype ~= 'oil' then
    oil.open(current_dir)
    return
  end

  -- Block traversal if already at project root
  if current_dir == root then
    vim.notify('Reached project root', vim.log.levels.WARN, { title = 'Oil' })
    return
  end

  -- Compute explicit parent directory path
  local parent_dir = vim.fs.dirname(current_dir)
  oil.open(parent_dir)
end

return M
