-- Neovim Statusbar

vim.o.cmdheight = 0 -- Hide command line when not being used

local function search_result()
  -- Only execute tracking logic if search highlighting is currently active
  if vim.v.hlsearch == 0 then
    return ''
  end

  -- Safely call Neovim's internal search calculator
  local res = vim.fn.searchcount { maxcount = 999, timeout = 500 }

  -- If there are no occurrences or formatting properties are empty, return blank
  if res.total == 0 then
    return ''
  end

  -- Format output string exactly as [current/total]
  return string.format(' [%d/%d]', res.current, res.total)
end

-- TODO: find a way to remove this workaround
vim.api.nvim_create_autocmd('RecordingEnter', {
  desc = 'Show command line when recording macros',
  callback = function()
    vim.opt.cmdheight = 1
  end,
})
vim.api.nvim_create_autocmd('RecordingLeave', {
  desc = 'Hide command line when not recording macros',
  callback = function()
    vim.opt.cmdheight = 0
  end,
})

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    options = {
      globalstatus = true, -- enable global single statusline at neovim bottom
    },

    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = { 'filename' },

      -- 2. Inject the custom search component into your preferred section
      lualine_x = { search_result, 'encoding', 'fileformat', 'filetype' },

      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  },
}
