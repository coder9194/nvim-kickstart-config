-- Adds indentation guides to Neovim.

return {
  'lukas-reineke/indent-blankline.nvim',
  dependiences = {
    'HiPhish/rainbow-delimiters.nvim',
  },
  main = 'ibl',
  config = function()
    local highlight = {
      'RainbowRed',
      'RainbowYellow',
      'RainbowBlue',
      'RainbowOrange',
      'RainbowGreen',
      'RainbowViolet',
      'RainbowCyan',
    }

    local hooks = require 'ibl.hooks'
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
      vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
      vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
      vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
      vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
      vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
      vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
    end)

    local javascript_nodes = { 'object', 'array', 'return_statement' }

    vim.g.rainbow_delimiters = { highlight = highlight }
    require('ibl').setup {
      scope = {
        highlight = highlight,
        -- Add extra nodes of different languages here which are not highlighted by default
        -- `node_type` is the file extension
        -- (node keys can be found in `InspectTree`, e.g. `table_constructor` in `value: (table_constructor ; [9, 22] - [17, 5]`)
        include = {
          node_type = {
            lua = { 'return_statement', 'table_constructor' },
            js = javascript_nodes,
            ts = javascript_nodes,
            jsx = javascript_nodes,
            tsx = javascript_nodes,
          },
        },
      },
    }

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}
