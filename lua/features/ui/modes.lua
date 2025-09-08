local normal_cursor_color = require('constants.nvim').MODE_COLORS.NORMAL
local normal_cursor_line_color = require('constants.nvim').MODE_COLORS.NORMAL_CURSOR_LINE
local insert_cursor_color = require('constants.nvim').MODE_COLORS.INSERT
local visual_cursor_color = require('constants.nvim').MODE_COLORS.VISUAL

local function set_colors_by_mode()
  local new_mode = vim.fn.mode()
  if new_mode == 'n' then
    vim.api.nvim_set_hl(0, 'Cursor', { bg = normal_cursor_color, fg = '#ffffff' })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = normal_cursor_line_color })
  elseif new_mode == 'i' then
    vim.api.nvim_set_hl(0, 'Cursor', { bg = insert_cursor_color, fg = '#000000' })
  elseif new_mode == 'v' or new_mode == 'V' or new_mode == '\22' then
    vim.api.nvim_set_hl(0, 'Cursor', { bg = visual_cursor_color, fg = '#000000' })
  end
end

-- Auto command to trigger on mode changes
vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
  pattern = '*',
  callback = function()
    set_colors_by_mode()
  end,
})

-- Set cursor & cursor line color based on mode
return {
  'mvllow/modes.nvim',
  event = 'VeryLazy',
  config = function()
    set_colors_by_mode()
    require('modes').setup {
      colors = {
        copy = require('constants.nvim').MODE_COLORS.NORMAL,
        insert = require('constants.nvim').MODE_COLORS.INSERT,
        visual = require('constants.nvim').MODE_COLORS.VISUAL,
      },
      line_opacity = 0.3,
      set_cursor = true,
      set_cursorline = false, -- Keep cursor line shown on other windows
    }
  end,
}
