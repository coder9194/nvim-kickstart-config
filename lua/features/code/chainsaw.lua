-- Speed up log creation. Create various kinds of language-specific log statements, such as logs of variables, assertions, or time-measuring.
-- https://github.com/chrisgrieser/nvim-chainsaw

local prettierLogSingleFormat = {
  '/* prettier-ignore */ // {{marker}}', -- adding this line
  'console.log(`{{marker}} `);',
}
local prettierLogMultipleFormat = {
  '/* prettier-ignore */ // {{marker}}', -- adding this line
  "console.log('{{marker}} {{var}}: ', {{var}});",
}

return {
  'chrisgrieser/nvim-chainsaw',
  opts = {
    marker = '🐱',
    logHighlightGroup = false,
    logStatements = {
      variableLog = {
        javascript = prettierLogMultipleFormat,
        typescript = prettierLogMultipleFormat,
        typescriptreact = prettierLogMultipleFormat,
      },
      objectLog = {
        javascript = prettierLogMultipleFormat,
        typescript = prettierLogMultipleFormat,
        typescriptreact = prettierLogMultipleFormat,
      },
      assertLog = {
        javascript = prettierLogMultipleFormat,
        typescript = prettierLogMultipleFormat,
        typescriptreact = prettierLogMultipleFormat,
      },
      messageLog = {
        javascript = prettierLogSingleFormat,
        typescript = prettierLogSingleFormat,
        typescriptreact = prettierLogSingleFormat,
      },
      stacktraceLog = {
        javascript = prettierLogMultipleFormat,
        typescript = prettierLogMultipleFormat,
        typescriptreact = prettierLogMultipleFormat,
      },
      beepLog = {
        javascript = prettierLogMultipleFormat,
        typescript = prettierLogMultipleFormat,
        typescriptreact = prettierLogMultipleFormat,
      },
      timeLog = {
        javascript = prettierLogMultipleFormat,
        typescript = prettierLogMultipleFormat,
        typescriptreact = prettierLogMultipleFormat,
      },
      debugLog = {
        javascript = prettierLogMultipleFormat,
        typescript = prettierLogMultipleFormat,
        typescriptreact = prettierLogMultipleFormat,
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>cla", mode = "n", function() require("chainsaw").assertLog() end, desc = "Assert log", },
    { "<leader>clb", mode = "n", function() require("chainsaw").beepLog() end, desc = "Beep log", },
    { "<leader>cld", mode = "n", function() require("chainsaw").debugLog() end, desc = "Debug log", },
    { "<leader>clD", mode = "n", function() require("chainsaw").removeLogs() end, desc = "Delete logs", },
    { "<leader>clm", mode = "n", function() require("chainsaw").messageLog() end, desc = "Message log", },
    { "<leader>clo", mode = "n", function() require("chainsaw").objectLog() end, desc = "Object log", },
    { "<leader>clt", mode = "n", function() require("chainsaw").timeLog() end, desc = "Time log", },
    { "<leader>clv", mode = "n", function() require("chainsaw").variableLog() end, desc = "Variable log", },
  },
}
