vim.opt.autoread = true -- Enable auto-reload for externally changed files

-- Create autocmd group to trigger 'checktime' on focus and cursor events
local auto_reload_group = vim.api.nvim_create_augroup('AutoReloadBuffer', { clear = true })

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI', 'TermClose' }, {
  group = auto_reload_group,
  callback = function()
    -- Avoid executing checktime inside command-line window
    if vim.fn.getcmdwintype() == '' then
      vim.cmd 'checktime'
    end
  end,
})

-- Optional: Notify when a buffer is automatically reloaded
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  group = auto_reload_group,
  callback = function()
    vim.notify('File changed on disk. Buffer reloaded.', vim.log.levels.INFO, { title = 'Auto-Reload' })
  end,
})

return {}
