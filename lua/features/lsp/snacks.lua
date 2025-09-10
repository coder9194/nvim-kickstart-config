return {
  'folke/snacks.nvim',
  -- stylua: ignore
  keys={
    -- gd
    { "gdd", mode = "n", function() require("utils.snacks").goto_lsp_definitions() end, desc = "In current window", },
    { "gdh", mode = "n", function() require("utils.window").run_in_left_window({ callback = require("utils.snacks").goto_lsp_definitions, }) end, desc = "In left window", },
    { "gdj", mode = "n", function() require("utils.window").run_in_below_window({ callback = require("utils.snacks").goto_lsp_definitions, }) end, desc = "In below window", },
    { "gdk", mode = "n", function() require("utils.window").run_in_above_window({ callback = require("utils.snacks").goto_lsp_definitions, }) end, desc = "In above window", },
    { "gdl", mode = "n", function() require("utils.window").run_in_right_window({ callback = require("utils.snacks").goto_lsp_definitions, }) end, desc = "In right window", },
    { "gdt", mode = "n", function() require("utils.tab").run_in_new_tab({ callback = require("utils.snacks").goto_lsp_definitions, }) end, desc = "In new tab", },

    -- gI
    { "gII", mode = "n", function() require('utils.snacks').goto_lsp_implementations() end, desc = "In current window", },
    { "gIh", mode = "n", function() require("utils.window").run_in_left_window({ callback = require('utils.snacks').goto_lsp_implementations, }) end, desc = "In left window", },
    { "gIj", mode = "n", function() require("utils.window").run_in_below_window({ callback = require('utils.snacks').goto_lsp_implementations, }) end, desc = "In below window", },
    { "gIk", mode = "n", function() require("utils.window").run_in_above_window({ callback = require('utils.snacks').goto_lsp_implementations, }) end, desc = "In above window", },
    { "gIl", mode = "n", function() require("utils.window").run_in_right_window({ callback = require('utils.snacks').goto_lsp_implementations, }) end, desc = "In right window", },
    { "gIt", mode = "n", function() require("utils.tab").run_in_new_tab({ callback = require('utils.snacks').goto_lsp_implementations, }) end, desc = "In new tab", },

    -- gy
    { "gyy", mode = "n", function() require('utils.snacks').goto_lsp_type_definitions() end, desc = "In current window", },
    { "gyh", mode = "n", function() require("utils.window").run_in_left_window({ callback = require('utils.snacks').goto_lsp_type_definitions, }) end, desc = "In left window", },
    { "gyj", mode = "n", function() require("utils.window").run_in_below_window({ callback = require('utils.snacks').goto_lsp_type_definitions, }) end, desc = "In below window", },
    { "gyk", mode = "n", function() require("utils.window").run_in_above_window({ callback = require('utils.snacks').goto_lsp_type_definitions, }) end, desc = "In above window", },
    { "gyl", mode = "n", function() require("utils.window").run_in_right_window({ callback = require('utils.snacks').goto_lsp_type_definitions, }) end, desc = "In right window", },
    { "gyt", mode = "n", function() require("utils.tab").run_in_new_tab({ callback = require('utils.snacks').goto_lsp_type_definitions, }) end, desc = "In new tab", },
  }
,
}
