-- Show LSP notifications
local progress = {}
local progress_timer = nil
vim.api.nvim_create_autocmd('LspProgress', {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value
    if not client or type(value) ~= 'table' then
      return
    end

    -- Ensure client table exists
    progress[client.id] = progress[client.id] or {}
    local p = progress[client.id]

    -- Update or append token state
    local token = ev.data.params.token
    local found = false
    for i, item in ipairs(p) do
      if item.token == token then
        item.msg = string.format(
          '[%3d%%] %s%s',
          value.kind == 'end' and 100 or value.percentage or 100,
          value.title or '',
          value.message and (' **%s**'):format(value.message) or ''
        )
        item.done = (value.kind == 'end')
        found = true
        break
      end
    end

    if not found then
      table.insert(p, {
        token = token,
        msg = string.format(
          '[%3d%%] %s%s',
          value.kind == 'end' and 100 or value.percentage or 100,
          value.title or '',
          value.message and (' **%s**'):format(value.message) or ''
        ),
        done = (value.kind == 'end'),
      })
    end

    -- Filter out completed progress tokens
    local active_p = {}
    local msg = {}
    for _, item in ipairs(p) do
      table.insert(msg, item.msg)
      if not item.done then
        table.insert(active_p, item)
      end
    end
    progress[client.id] = active_p

    -- Throttle notify calls to avoid spamming snacks_notif on every character
    if progress_timer then
      return
    end
    progress_timer = vim.defer_fn(function()
      progress_timer = nil
      local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
      local is_done = #progress[client.id] == 0

      vim.notify(table.concat(msg, '\n'), vim.log.levels.INFO, {
        id = 'lsp_progress_' .. client.id,
        title = client.name,
        opts = function(notif)
          notif.icon = is_done and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
      })
    end, 100) -- Only notify at most once every 100ms
  end,
})

return {
  {
    'folke/snacks.nvim',
    opts = {
      notifier = {
        enabled = true,
        top_down = false, -- Show notify messages on bottom right
      },
    },
    -- stylua: ignore
    keys = {
      { '<leader>nd', function() require('snacks.notifier').hide() end, desc = 'Dismiss Notification', },
      { '<leader>nh', function() require('snacks.notifier').show_history() end, desc = 'Notifications', },
    },
  },
  {
    'folke/noice.nvim',
    opts_extend = {
      'lsp.progress',
    },
    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
      },
    },
  },
}
