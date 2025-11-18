vim.api.nvim_create_autocmd('UIEnter', {
  desc = 'Override treesitter context highlight',
  group = vim.api.nvim_create_augroup('treesitter-context-override', { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, 'TreesitterContext', { underline = false, bg = 'NONE' })
  end,
})

return {
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require('treesitter-context').setup {
      enable = true,
      max_lines = 4, -- limit context window to at most 3 lines
      trim_scope = 'outer', -- how to trim when max_lines is reached
      separator = '─',
    }
  end,
}
