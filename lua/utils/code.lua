local M = {}

function M.lint_project_by_eslint()
  local snacks = require 'snacks'

  local notif_id = snacks.notify('Running ESLint...', {
    title = 'ESLint',
    timeout = false,
    level = 'info',
  })

  local stdout_data = {}
  local stderr_data = {}

  local job_id = vim.fn.jobstart('npx eslint ./src -f unix', {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= '' then
            table.insert(stdout_data, line)
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= '' then
            table.insert(stderr_data, line)
          end
        end
      end
    end,
    on_exit = function(_, exit_code)
      local qf_lines = {}
      for _, line in ipairs(stdout_data) do
        if not line:match '^%d+ problem[s]?$' then
          table.insert(qf_lines, line)
        end
      end

      if exit_code == 0 then
        vim.fn.setqflist({}, ' ', {
          title = 'eslint',
          lines = qf_lines,
        })
        snacks.notify('No ESLint issues found!', {
          title = 'ESLint',
          level = 'info',
          replace = notif_id,
        })
      elseif exit_code == 1 then
        vim.fn.setqflist({}, ' ', {
          title = 'eslint',
          lines = qf_lines,
        })
        vim.cmd 'Trouble quickfix'
        snacks.notify('ESLint completed with issues.', {
          title = 'ESLint',
          level = 'warn',
          replace = notif_id,
        })
      else
        -- exit_code >= 2: real error
        local err_msg = table.concat(stderr_data, '\n')
        if err_msg == '' then
          err_msg = 'Unknown error running ESLint.'
        end
        snacks.notify('ESLint encountered an error:\n' .. err_msg, {
          title = 'ESLint',
          level = 'error',
          replace = notif_id,
          timeout = 5000,
        })
      end
    end,
  })
end

return M
