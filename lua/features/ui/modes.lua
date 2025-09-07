-- Set cursor & cursor line color based on mode

return {
  'mvllow/modes.nvim',
  event = 'VeryLazy',
  config = function()
    vim.cmd 'highlight Cursor guibg=#85dad2'
    vim.cmd 'highlight CursorLine guibg=#424F4C'
    require('modes').setup {
      colors = {
        copy = '#85dad2',
        delete = '#c75c6a',
        insert = '#adda78',
        visual = '#fd6883',
      },
      line_opacity = 0.2,
      skt_cursor = true,
      set_cursorline = false,
    }
  end,
}
