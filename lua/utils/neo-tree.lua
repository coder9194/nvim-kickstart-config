local M = {}

function M.reveal_tree()
  if vim.bo.filetype ~= 'neo-tree' then
    vim.cmd.Neotree { 'position=float', 'reveal' }
  end
end

function M.open_file_in_above(state)
  local node = state.tree:get_node()
  local path = node:get_id()
  require('neo-tree.utils').open_file(state, path, 'split')
  vim.wait(require('constants.nvim').WAITING_TIME)
  require('utils.window').swap_windows 'up'
end

return M
