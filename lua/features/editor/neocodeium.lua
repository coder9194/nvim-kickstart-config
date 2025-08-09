-- NeoCodeium provides AI completion powered by Codeium and address the issue of flickering suggestions in the official plugin
-- https://github.com/monkoose/neocodeium

vim.b.completion = false

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuOpen',
  callback = function()
    require('neocodeium').clear()
  end,
})
vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuPositionUpdate',
  callback = function()
    require('neocodeium').clear()
  end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'TextChangedI' }, {
  callback = function()
    local is_neocodeium_disabled = require('neocodeium').get_status()
    local is_blink_menu_shown = require('blink.cmp').is_visible()

    if is_neocodeium_disabled and not is_blink_menu_shown then
      require('neocodeium').cycle_or_complete()
    end
  end,
})

local is_first_tab_pressed = false
local function handle_multiple_tab_presses()
  local is_blink_menu_shown = require('blink.cmp').is_visible()

  if is_blink_menu_shown then
    require('blink.cmp').accept { callback = require('blink.cmp').show }
    return
  end

  if not is_first_tab_pressed then
    is_first_tab_pressed = true
    -- Start waiting for second `<tab>` for a short ms
    vim.fn.timer_start(200, function()
      if is_first_tab_pressed then
        is_first_tab_pressed = false
        require('neocodeium').accept_word()
      end
    end)
  else
    -- Mapped for `<tab><tab>`
    is_first_tab_pressed = false
    require('neocodeium').accept()
  end
end
vim.keymap.set('i', '<tab>', handle_multiple_tab_presses, { expr = true, silent = true, noremap = true })

return {
  {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    config = function()
      vim.b.completion = false
      require('neocodeium').setup {}
    end,
    keys = {
      {
        '<leader>cC',
        mode = 'n',
        function()
          require('neocodeium').chat()
        end,
        desc = 'Chat with NeoCodeium',
      },
    },
  },
  {
    'saghen/blink.cmp',
    opts_extend = {
      'completion',
      'keymap',
    },
    opts = {
      completion = {
        ghost_text = {
          enabled = false,
        },
      },
      -- Keymaps when menu is shown
      keymap = {
        preset = 'none',
        -- stylua: ignore start
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<c-n>"] = { "select_next" },
        ["<c-p>"] = { "select_prev" },
        -- stylua: ignore end
      },
    },
    -- stylua: ignore
    keys = {
      { '<c-c>', mode = 'n', function() require('utils.nvim').send_keys 'e' require('utils.nvim').send_keys 'a' vim.defer_fn(function() vim.b.completion = true require('blink.cmp').show() end, 100) end, desc = 'Suggest Imports', },
      { '<c-c>', mode = 'i', function() vim.b.completion = true require('blink.cmp').show() end, desc = 'Suggest Imports', },
      { '<esc>', mode = 'i', function() local is_blink_menu_shown = require('blink.cmp').is_visible() if is_blink_menu_shown then require('blink.cmp').hide() vim.b.completion = false require('neocodeium').cycle_or_complete() else vim.cmd 'stopinsert' end end, },
    },
  },
}
