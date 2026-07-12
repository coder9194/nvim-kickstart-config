local lsp_git_watcher_group = vim.api.nvim_create_augroup('LspGitWatcher', { clear = true })

vim.api.nvim_create_autocmd('VimEnter', {
  group = lsp_git_watcher_group,
  callback = function()
    -- Locate the root .git directory for the current project path
    local git_dir = vim.fn.finddir('.git', '.;')
    if git_dir == '' then
      return
    end

    local git_dir_full = vim.fn.fnamemodify(git_dir, ':p')

    -- Initialize libuv file system event watcher
    local w = vim.uv.new_fs_event()
    if not w then
      return
    end

    -- Watch the entire .git/ folder instead of the file directly
    -- to survive inode deletions and unlinks during git switch
    w:start(
      git_dir_full,
      {},
      vim.schedule_wrap(function(err, filename, events)
        if err then
          w:stop()
          return
        end

        -- Only trigger if the modified file within the directory is specifically HEAD
        if filename == 'HEAD' then
          local active_clients = vim.lsp.get_clients()
          if #active_clients > 0 then
            -- Stop each client directly via API to bypass active buffer checks
            for _, client in ipairs(active_clients) do
              local client_obj = vim.lsp.get_client_by_id(client.id)
              if client_obj then
                client_obj:stop(true)
              end
            end

            -- ONLY reload buffers that are visible in active windows
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_is_valid(win) then
                local buf = vim.api.nvim_win_get_buf(win)
                local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })

                if buftype == '' then
                  vim.api.nvim_win_call(win, function()
                    vim.cmd 'edit!'
                  end)
                end
              end
            end
          end
        end
      end)
    )

    -- Clean up the system file handle resource cleanly when exiting Neovim
    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = lsp_git_watcher_group,
      callback = function()
        if w:is_active() then
          w:stop()
        end
      end,
    })
  end,
})

return {}
