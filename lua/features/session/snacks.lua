vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local is_no_file_opened = vim.fn.argc() == 0
    if is_no_file_opened then
      require('snacks').dashboard()
    end
  end,
})

return {
  'folke/snacks.nvim',
  opts = {
    dashboard = {
      enabled = true,
    },
  },
}
