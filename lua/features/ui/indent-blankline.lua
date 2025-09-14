-- Adds indentation guides to Neovim.

return {
  'lukas-reineke/indent-blankline.nvim',
  dependiences = {
    'HiPhish/rainbow-delimiters.nvim',
  },

  main = 'ibl',
  event = 'UIEnter',
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

    local javascript_nodes = {
      -- objects/collections
      'object',
      'pair',
      'array',
      'object_pattern',
      'array_pattern',

      -- properties / assignments
      'property_identifier',
      'property',
      'property_assignment',
      'shorthand_property_identifier',

      -- functions / calls / member access
      'call_expression',
      'new_expression',
      'arguments',
      'arrow_function',
      'function_declaration',
      'function_expression',
      'parenthesized_expression',
      'subscript_expression',

      -- module / import
      'import_statement',
      'import_specifier',
      'import_call',
      'require_call',

      -- control + returns
      'return_statement',
      'if_statement',
      'for_statement',
      'while_statement',
      'switch_statement',

      -- JSX / TSX
      'jsx_element',
      'jsx_self_closing_element',
      'jsx_fragment',
      'jsx_expression',
      'jsx_attribute',

      -- generic
      'program',
      'expression_statement',
      'variable_declaration',
      'variable_declarator',
    }

    vim.g.rainbow_delimiters = { highlight = highlight }
    require('ibl').setup {
      scope = {
        highlight = highlight,
        -- Add extra nodes of different languages here which are not highlighted by default
        -- `node_type` can be found in the first table (right value) of `https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua`
        -- (node keys can be found in `InspectTree`, e.g. `table_constructor` in `value: (table_constructor ; [9, 22] - [17, 5]`)
        include = {
          node_type = {
            lua = { 'return_statement', 'table_constructor' },
            javascript = javascript_nodes,
            typescript = javascript_nodes,
            tsx = javascript_nodes,
          },
        },
      },
    }

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}
