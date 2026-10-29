require('utils.nvim').safely_delete_keymap({ 'n', 'v' }, 'gra') -- Disable default code actions
require('utils.nvim').safely_delete_keymap('n', 'grn') -- Disable default code rename
require('utils.nvim').safely_delete_keymap('n', 'grx') -- Disable default codelens

return {
  {
    'folke/which-key.nvim',
    opts_extend = {
      'spec',
    },
    opts = {
      spec = {
        { 'gr', group = 'LSP actions' },
      },
    },
  },
  {
    'folke/snacks.nvim',
  -- stylua: ignore
  keys={
    { 'grd', function() require('snacks.picker').lsp_definitions { auto_confirm = false } end, desc = 'LSP Definitions', },
    { 'gri', function() require('snacks.picker').lsp_implementations { auto_confirm = false } end, desc = 'LSP Implementations', },
    { 'grr', function() require('snacks.picker').lsp_references { auto_confirm = false } end, desc = 'LSP References', },
    { 'grt', function() require('snacks.picker').lsp_type_definitions { auto_confirm = false } end, desc = 'LSP Type Definitions', },
    { 'grD', function() require('snacks.picker').lsp_declarations { auto_confirm = false } end, desc = 'LSP Declarations', },
  },
  },
}
