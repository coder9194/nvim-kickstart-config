return {
  {
    'OXY2DEV/markview.nvim',
    config = function()
      require('markview').setup {
        filetypes = { 'markdown', 'quarto', 'rmd' }, -- Only enable for markdown-related buffers
        buf_ignore = {}, -- Prevents global attachment to tsx, jsx, lua, etc.
        -- Disable markview features in insert mode completely
        modes = { 'n', 'v', 'V', '\22' }, -- Exclude 'i' and 'ic'
      }

      vim.schedule(function()
        -- 1. Remove markview from CursorMovedI so it never runs during Insert typing
        for _, autocmd in ipairs(vim.api.nvim_get_autocmds { event = 'CursorMovedI' }) do
          if autocmd.callback and tostring(autocmd.callback):find 'markview' then
            pcall(vim.api.nvim_del_autocmd, autocmd.id)
          end
        end

        -- 2. Ensure incline stays completely removed from CursorMovedI
        local incline_group = pcall(vim.api.nvim_create_augroup, 'incline', { clear = false })
        if incline_group then
          pcall(vim.api.nvim_clear_autocmds, { group = 'incline', event = 'CursorMovedI' })
        end
      end)
    end,
  },
}
