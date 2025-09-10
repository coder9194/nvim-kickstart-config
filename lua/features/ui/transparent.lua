-- Remove all background colors to make nvim transparent.
-- https://github.com/xiyaowong/transparent.nvim

return {
  'xiyaowong/transparent.nvim',
  config = function()
    -- Other plugins
    -- require('transparent').clear_prefix 'NeoTree'
    require('transparent').clear_prefix 'WhichKeyFloat'
    vim.cmd "highlight Pmenu guibg='none'" -- Set background color of suggestion popup

    -- Floating window
    vim.cmd 'set pumblend=0'
    require('transparent').clear_prefix 'Float'
    require('transparent').clear_prefix 'NormalFloat'
    require('transparent').clear_prefix 'FloatBorder'
    require('transparent').clear_prefix 'FloatTitle'
    require('transparent').clear_prefix 'InclineNormal'

    -- Winbar (used in incline.nvim)
    require('transparent').clear_prefix 'WinBar'
    require('transparent').clear_prefix 'WinBarNC'

    require('transparent').setup { -- Optional, you don't have to run setup.
      groups = { -- table: default groups
        'Normal',
        'NormalNC',
        'Comment',
        'Constant',
        'Special',
        'Identifier',
        'Statement',
        'PreProc',
        'Type',
        'Underlined',
        'Todo',
        'String',
        'Function',
        'Conditional',
        'Repeat',
        'Operator',
        'Structure',
        'LineNr',
        'NonText',
        'SignColumn',
        'StatusLine',
        'StatusLineNC',
        'EndOfBuffer',
      },
      extra_groups = {}, -- table: additional groups that should be cleared
      exclude_groups = {}, -- table: groups you don't want to clear
    }

    vim.cmd 'TransparentEnable'
  end,
}
