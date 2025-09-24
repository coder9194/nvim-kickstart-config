vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Load format options when Vim is started',
  callback = function()
    -- Default indent settings
    vim.opt.expandtab = true -- Use spaces instead of tabs
    vim.opt.tabstop = 2 -- Number of spaces a tab counts for
    vim.opt.shiftwidth = 2 -- Number of spaces for autoindent
    vim.opt.softtabstop = 2 -- Number of spaces a <Tab> inserts
  end,
})

return {} -- For file to be loaded without error
