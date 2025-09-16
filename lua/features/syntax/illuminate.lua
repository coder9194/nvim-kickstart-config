-- TODO: fix highlight of current word when cursor on it
-- vim.g.Illuminate_highlightUnderCursor = 0
-- vim.cmd 'hi def IlluminatedWordText gui=underline cterm=underline'
-- vim.cmd 'hi def IlluminatedWordRead gui=underline cterm=underline'
-- vim.cmd 'hi def IlluminatedWordWrite gui=underline cterm=underline'

return {
  'RRethy/vim-illuminate',
  config = function()
    require('illuminate').configure {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
    }
  end,
  -- stylua: ignore
  keys = {
    { 'HH', function() require('illuminate').goto_prev_reference() end, desc = 'Previous word', },
    { 'LL', function() require('illuminate').goto_next_reference() end, desc = 'Next word', },
  },
}
