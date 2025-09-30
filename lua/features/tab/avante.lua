local avante_keymap_group = vim.api.nvim_create_augroup('AvanteBufferKeymaps', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
  group = avante_keymap_group,
  callback = function()
    local is_avante_tab = require('utils.avante').is_avante_tab()

    if is_avante_tab then
      require('utils.avante').set_tab_keymaps 'Avante Ask'
    else
      require('utils.avante').clear_tab_keymaps()
    end
  end,
})

vim.api.nvim_create_autocmd('BufLeave', {
  group = avante_keymap_group,
  callback = function()
    local is_avante_tab = require('utils.avante').is_avante_tab()

    if is_avante_tab then
      require('utils.avante').clear_tab_keymaps()
    end
  end,
})

return {
  -- https://github.com/yetone/avante.nvim
  'yetone/avante.nvim',
}
