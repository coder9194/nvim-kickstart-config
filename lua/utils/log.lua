local log = {}

local function get_caller_info()
  -- Stack depth 4 resolves to the caller of log.debug/info/warn/error
  local info = debug.getinfo(4, 'Sl')
  if not info or not info.short_src then
    return '', 0
  end
  return info.short_src, info.currentline or 0
end

-- Custom log function with custom log level
local function emit(level, level_name, ...)
  local current_level = require('constants.nvim').LOG.LEVEL
  if level < current_level then
    return
  end

  local src, line = get_caller_info()

  local target_file = require('constants.nvim').LOG.TARGET_FILE
  if target_file and target_file ~= '' then
    if not src:find(target_file, 1, true) then
      return
    end
  end

  local args = { ... }
  local parts = {}

  for i, v in ipairs(args) do
    parts[i] = type(v) == 'string' and v or vim.inspect(v)
  end
  local msg = table.concat(parts, ' ')

  -- Extract short file name and append line number to notification title
  local filename = src:match '^.+/(.+)$' or src
  local title = string.format('%s [%s:%d]', level_name, filename, line)

  vim.notify(msg, level, { title = title })
end

function log.trace(...)
  emit(vim.log.levels.TRACE or 0, 'TRACE', ...)
end

function log.debug(...)
  emit(vim.log.levels.DEBUG, 'DEBUG', ...)
end

function log.info(...)
  emit(vim.log.levels.INFO, 'INFO', ...)
end

function log.warn(...)
  emit(vim.log.levels.WARN, 'WARN', ...)
end

function log.error(...)
  emit(vim.log.levels.ERROR, 'ERROR', ...)
end

return log
