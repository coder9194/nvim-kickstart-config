-- Move any selection in any direction
return {
  'nvim-mini/mini.move',
  version = false,
  -- No need to copy this inside `setup()`. Will be used automatically.
  opts = {
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = '<M-H>',
      right = '<M-L>',
      down = '<M-J>',
      up = '<M-K>',

      -- Move current line in Normal mode
      line_left = '<M-H>',
      line_right = '<M-L>',
      line_down = '<M-J>',
      line_up = '<M-K>',
    },

    -- Options which control moving behavior
    options = {
      -- Automatically reindent selection during linewise vertical move
      reindent_linewise = true,
    },
  },
}
