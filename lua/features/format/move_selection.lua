return {
  {
    'fedepujol/move.nvim',
    opts = {
      line = {
        enable = true, -- Enables line movement
        indent = true, -- Toggles indentation
      },
      block = {
        enable = true, -- Enables block movement
        indent = true, -- Toggles indentation
      },
      word = {
        enable = true, -- Enables word movement
      },
      char = {
        enable = true, -- Enables char movement
      },
    },
    keys = {
      -- Normal Mode
      { '<A-j>', ':MoveLine(1)<CR>', desc = 'Move Line Up' },
      { '<A-k>', ':MoveLine(-1)<CR>', desc = 'Move Line Down' },
      { '<A-h>', ':MoveHChar(-1)<CR>', desc = 'Move Character Left' },
      { '<A-l>', ':MoveHChar(1)<CR>', desc = 'Move Character Right' },
      -- Visual Mode
      { '<A-j>', ':MoveBlock(1)<CR>', mode = { 'v' }, desc = 'Move Block Up' },
      { '<A-k>', ':MoveBlock(-1)<CR>', mode = { 'v' }, desc = 'Move Block Down' },
      { '<A-h>', ':MoveHBlock(-1)<CR>', mode = { 'v' }, desc = 'Move Block Left' },
      { '<A-l>', ':MoveHBlock(1)<CR>', mode = { 'v' }, desc = 'Move Block Right' },
    },
  },
}
