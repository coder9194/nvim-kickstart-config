return {
  'nvim-mini/mini.animate',
  opts = {
    cursor = {
      enable = false,
    },
    scroll = {
      enable = false,
      time = 300,
    },
    resize = {
      enable = true,
      time = 300,
    },
    -- Disable fade effect on window open and close as it looks weird on transparent background
    open = { enable = false },
    close = { enable = false },
  },
}
