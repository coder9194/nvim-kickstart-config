-- Hover popup (including LSP hover, signature help, and diagnostics)
vim.o.winborder = 'rounded'

-- Input popup
return {
  'stevearc/dressing.nvim',
  opts = {
    input = {
      enabled = true,
      default_prompt = 'Input:',
      title_pos = 'left',

      prefer_builtin = false, -- Force the custom floating UI

      -- Window styling parameters parameters
      border = 'rounded',
      relative = 'cursor',
      row = 0,
      col = 1,

      -- This hook configures the buffer keys
      mappings = {
        n = {
          ['<Esc>'] = 'Close', -- In Normal mode, Esc closes the rename prompt
          ['<Cr>'] = 'Confirm', -- Enter confirms the new name
        },
        i = {
          ['<Cr>'] = 'Confirm', -- Enter confirms while typing
          -- We leave <Esc> alone in insert mode so it drops you to normal mode!
        },
      },
    },
  },
}
