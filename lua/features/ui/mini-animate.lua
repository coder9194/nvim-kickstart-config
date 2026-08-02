-- Remove mini.animate's residual CursorMoved listener

return {
  'nvim-mini/mini.animate',
  config = function()
    require('mini.animate').setup {
      cursor = {
        enable = false,
      },
      scroll = {
        enable = false,
        time = 300,
      },
      resize = {
        enable = true,
        time = 300,
      },
      -- Disable fade effect on window open and close as it looks weird on transparent background
      open = { enable = false },
      close = { enable = false },
    }
    --
    -- Defer execution until after mini.animate registers its autocmds
    vim.schedule(function()
      pcall(function()
        for _, autocmd in ipairs(vim.api.nvim_get_autocmds { event = { 'CursorMoved', 'CursorMovedI' } }) do
          if autocmd.group_name and autocmd.group_name:find 'MiniAnimate' then
            vim.api.nvim_clear_autocmds { group = autocmd.group_name }
          end
        end
      end)
    end)
  end,
}
