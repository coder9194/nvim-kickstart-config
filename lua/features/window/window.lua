local function close_windows_until_quit()
  -- Repeatedly pick and close windows until user cancels with <Esc>
  while true do
    local before = vim.api.nvim_get_current_win()
    require('nvim-window').pick()
    local after = vim.api.nvim_get_current_win()
    -- If the window didn't change, user likely canceled with <Esc>; stop
    if before == after then
      break
    end
    -- Safely close the selected window; stop if it fails (e.g. last window)
    local ok = pcall(function()
      vim.cmd 'close'
    end)
    if not ok then
      break
    end
  end
end

-- https://github.com/yorickpeterse/nvim-window
-- A simple and opinionated NeoVim plugin for switching between windows in the current tab page.
return {
  'yorickpeterse/nvim-window',
  opts = {
    -- stylua: ignore
    -- character squence
    chars = {
    'a', 's', 'd', 'f', 'q', 'w', 'e', 'r', 'j', 'k', 'l', 'm', 'p',
    'n', 'o', 'b', 'h', 'i', 'c', 't', 'u', 'v', 'g', 'x', 'y', 'z'
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>wds', close_windows_until_quit, desc = 'Select to close (repeat until Esc)', },
  },
}
