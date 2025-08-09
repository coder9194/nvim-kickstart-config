local M = {}

-- Get file path of current buffer
function M.get_current_buffer_file_path()
  return vim.fn.expand '%:p'
end

-- Get buffer ID of current buffer
function M.get_current_buffer_id()
  return require('utils.nvim').get_command_output "echo bufnr('%')"
end

-- Get file path of target buffer
---@param buffer_id integer
function M.get_file_path(buffer_id)
  return vim.api.nvim_buf_get_name(buffer_id)
end

-- Delete background buffers
function M.delete_background_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.fn.bufwinnr(buf) == -1 then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

return M
