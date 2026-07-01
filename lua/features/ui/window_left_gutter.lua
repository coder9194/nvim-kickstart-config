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

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = require('constants.ui').DIAGNOSTIC_ICONS.ERROR,
      [vim.diagnostic.severity.WARN] = require('constants.ui').DIAGNOSTIC_ICONS.WARN,
      [vim.diagnostic.severity.INFO] = require('constants.ui').DIAGNOSTIC_ICONS.INFO,
      [vim.diagnostic.severity.HINT] = require('constants.ui').DIAGNOSTIC_ICONS.HINT,
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}

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
