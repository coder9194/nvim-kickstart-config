return {
  'folke/snacks.nvim',
  -- stylua: ignore
  keys={
    { 'gd', function() require('snacks.picker').lsp_definitions { auto_confirm = false } end, desc = 'LSP Definitions', },
    { 'gi', function() require('snacks.picker').lsp_implementations { auto_confirm = false } end, desc = 'LSP Implementations', },
    { 'gr', function() require('snacks.picker').lsp_references { auto_confirm = false } end, desc = 'LSP References', },
    { 'gy', function() require('snacks.picker').lsp_type_definitions { auto_confirm = false } end, desc = 'LSP Type Definitions', },
    { 'gD', function() require('snacks.picker').lsp_declarations { auto_confirm = false } end, desc = 'LSP Declarations', },
  },
}
