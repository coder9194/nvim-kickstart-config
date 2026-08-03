local lsp_git_hook_group = vim.api.nvim_create_augroup('LspGitHook', {
  clear = true,
})
local lsp_restart_timer = nil
local git_watcher = nil
local is_notification_pending = false -- State tracking to prevent spam

-- Function to handle the actual LSP restart logic
local function restart_all_lsps()
  local active_clients = vim.lsp.get_clients()

  -- Reset our notification state tracking flag immediately
  is_notification_pending = false

  if #active_clients == 0 then
    return
  end

  -- This will now strictly execute exactly once at the absolute end of the rebase sequence
  vim.notify('Git operation completed! Restarting all LSPs cleanly...', vim.log.levels.INFO)
  for _, client in ipairs(active_clients) do
    vim.cmd('lsp restart ' .. client.name)
  end
end

-- Initialize the watcher targeting the global/local .git directory state
local function start_git_watcher()
  local git_dir = vim.fn.finddir('.git', '.;')
  if git_dir == '' then
    return
  end

  local full_git_path = vim.fn.fnamemodify(git_dir, ':p')
  local uv = vim.uv or vim.loop

  if git_watcher then
    git_watcher:stop()
  end

  git_watcher = uv.new_fs_event()

  git_watcher:start(full_git_path, {}, function(error, filename, events)
    if error then
      return
    end

    if filename == 'HEAD' or filename:match 'rebase%-' or filename == 'index' then
      vim.schedule(function()
        -- Debounce: Cancel the previous pending restart timer if Git is still actively running
        if lsp_restart_timer then
          vim.fn.timer_stop(lsp_restart_timer)
        end

        -- Only print or queue the initial notification once to avoid filling up snacks.nvim or your logs
        if not is_notification_pending then
          is_notification_pending = true
          vim.notify('Git changes detected, stabilizing environment...', vim.log.levels.WARN)
        end

        -- Wait (slightly increased for safety on long rebases)
        lsp_restart_timer = vim.fn.timer_start(1500, function()
          vim.schedule(restart_all_lsps)
        end)
      end)
    end
  end)
end

return {}
