local M = {}

M.WAITING_TIME = 100

-- Most colors are got from sonokai theme
M.MODE_COLORS = {
  NORMAL = '#85dad2',
  NORMAL_CURSOR_LINE = '#424f4c',
  INSERT = '#adda78',
  VISUAL = '#fd7883',
}

M.LOG = {
  LEVEL = vim.log.levels.INFO,
  TARGET_FILE = '', -- Set to empty string to disable filtering
}

return M
