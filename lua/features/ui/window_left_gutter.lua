-- Left gutter in every window are formated by (from left to right):
-- ┌───────────────┬──────────────┬───────────────┐
-- │  Signcolumn   │ Line Numbers │  Actual Code  │
-- │  (e.g., [!] ) │   (e.g., 42) │  function().. │
-- └───────────────┴──────────────┴───────────────┘
-- Adn snacks.nvim hijacks the entire rendering process of the statuscolumn string as
-- ┌───────────────┬──────────────┬───────────────┬───────────────┐
-- │  Snacks Left  │ Line Numbers │ Snacks Right  │  Actual Code  │
-- │ (Diagnostics) │   (e.g., 42) │  (Git Signs)  │  function().. │
-- └───────────────┴──────────────┴───────────────┴───────────────┘

return {
  {
    'folke/snacks.nvim',
    opts = {
      statuscolumn = {
        left = { 'fold', 'git' }, -- priority of signs on the right (high to low)
        right = { 'sign' }, -- priority of signs on the left (high to low)
        folds = {
          open = true, -- show open fold icons
          git_hl = true, -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { 'GitSign', 'MiniDiffSign' },
        },
        refresh = 100, -- refresh at most every 50ms
      },
    },
  },
}
