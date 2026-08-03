return {
  'folke/snacks.nvim',
  -- stylua: ignore
  keys={
    { 'grd', function() require('snacks.picker').lsp_definitions { auto_confirm = false } end, desc = 'LSP Definitions', },
    { 'gri', function() require('snacks.picker').lsp_implementations { auto_confirm = false } end, desc = 'LSP Implementations', },
    { 'grr', function() require('snacks.picker').lsp_references { auto_confirm = false } end, desc = 'LSP References', },
    { 'gry', function() require('snacks.picker').lsp_type_definitions { auto_confirm = false } end, desc = 'LSP Type Definitions', },
    { 'grD', function() require('snacks.picker').lsp_declarations { auto_confirm = false } end, desc = 'LSP Declarations', },
  },
}
