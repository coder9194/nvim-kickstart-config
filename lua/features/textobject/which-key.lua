return {
  'folke/which-key.nvim',
  opts_extend = {
    'spec',
  },
  opts = {
    spec = {
      { mode = 'v', 'a', group = 'outer' },
      { mode = 'v', 'i', group = 'inner' },
      { mode = 'v', 'gs', group = 'surround' },
    },
  },
}
