-- Allows you to print typescript types as inline virtual text and dynamically update it instantly without having to move the cursor over the inspected variable
-- https://github.com/marilari88/twoslash-queries.nvim

return {
  'marilari88/twoslash-queries.nvim',
  config = function()
    require('twoslash-queries').setup {}
    require('lspconfig')['vtsls'].setup {
      on_attach = function(client, bufnr)
        require('twoslash-queries').attach(client, bufnr)
      end,
    }
  end,
  opts = {
    multi_line = true,
  },
  keys = {
    { '<leader>cti', mode = 'n', '<cmd>TwoslashQueriesInspect<cr>', desc = 'Inspect variable type' },
    { '<leader>ctd', mode = 'n', '<cmd>TwoslashQueriesRemove<cr>', desc = 'Delete all inspected types' },
  },
}
