return {
  'folke/snacks.nvim',
  -- stylua: ignore
  keys={
    -- gd: Go to Definition
    { "gdd", mode = "n", function() require("utils.snacks").goto_lsp_definitions() end, desc = "In current window", },
    { "gdh", mode = "n", function() require("utils.window").run_in_left_window({ callback = require("utils.snacks").goto_lsp_definitions, }) end, desc = "In left window", },
    { "gdj", mode = "n", function() require("utils.window").run_in_below_window({ callback = require("utils.snacks").goto_lsp_definitions, }) end, desc = "In below window", },
    { "gdk", mode = "n", function() require("utils.window").run_in_above_window({ callback = require("utils.snacks").goto_lsp_definitions, }) end, desc = "In above window", },
    { "gdl", mode = "n", function() require("utils.window").run_in_right_window({ callback = require("utils.snacks").goto_lsp_definitions, }) end, desc = "In right window", },
    { "gdt", mode = "n", function() require("utils.tab").run_in_new_tab({ callback = require("utils.snacks").goto_lsp_definitions, }) end, desc = "In new tab", },

    -- gi: Go to Implementation
    { "gii", mode = "n", function() require('utils.snacks').goto_lsp_implementations() end, desc = "In current window", },
    { "gih", mode = "n", function() require("utils.window").run_in_left_window({ callback = require('utils.snacks').goto_lsp_implementations, }) end, desc = "In left window", },
    { "gij", mode = "n", function() require("utils.window").run_in_below_window({ callback = require('utils.snacks').goto_lsp_implementations, }) end, desc = "In below window", },
    { "gik", mode = "n", function() require("utils.window").run_in_above_window({ callback = require('utils.snacks').goto_lsp_implementations, }) end, desc = "In above window", },
    { "gil", mode = "n", function() require("utils.window").run_in_right_window({ callback = require('utils.snacks').goto_lsp_implementations, }) end, desc = "In right window", },
    { "git", mode = "n", function() require("utils.tab").run_in_new_tab({ callback = require('utils.snacks').goto_lsp_implementations, }) end, desc = "In new tab", },

    -- gr: Go to Reference
    {'grr', function() require('utils.snacks').goto_lsp_references() end, desc = 'In current window', },
    {'grh', function() require("utils.window").run_in_left_window({ callback = require('utils.snacks').goto_lsp_references, }) end, desc = 'In left window', },
    {'grj', function() require("utils.window").run_in_below_window({ callback = require('utils.snacks').goto_lsp_references, }) end, desc = 'In below window', },
    {'grk', function() require("utils.window").run_in_above_window({ callback = require('utils.snacks').goto_lsp_references, }) end, desc = 'In above window', },
    {'grl', function() require("utils.window").run_in_right_window({ callback = require('utils.snacks').goto_lsp_references, }) end, desc = 'In right window', },
    {'grt', function() require("utils.tab").run_in_new_tab({ callback = require('utils.snacks').goto_lsp_references, }) end, desc = 'In new tab', },

    -- gy: Go to Type Definition
    { "gyy", mode = "n", function() require('utils.snacks').goto_lsp_type_definitions() end, desc = "In current window", },
    { "gyh", mode = "n", function() require("utils.window").run_in_left_window({ callback = require('utils.snacks').goto_lsp_type_definitions, }) end, desc = "In left window", },
    { "gyj", mode = "n", function() require("utils.window").run_in_below_window({ callback = require('utils.snacks').goto_lsp_type_definitions, }) end, desc = "In below window", },
    { "gyk", mode = "n", function() require("utils.window").run_in_above_window({ callback = require('utils.snacks').goto_lsp_type_definitions, }) end, desc = "In above window", },
    { "gyl", mode = "n", function() require("utils.window").run_in_right_window({ callback = require('utils.snacks').goto_lsp_type_definitions, }) end, desc = "In right window", },
    { "gyt", mode = "n", function() require("utils.tab").run_in_new_tab({ callback = require('utils.snacks').goto_lsp_type_definitions, }) end, desc = "In new tab", },

    -- gD: Go to Declaration
    {'gDD', function() require('utils.snacks').goto_lsp_declarations() end, desc = 'In current window', },
    {'gDh', function() require("utils.window").run_in_left_window({ callback = require('utils.snacks').goto_lsp_declarations, }) end, desc = 'In left window', },
    {'gDj', function() require("utils.window").run_in_below_window({ callback = require('utils.snacks').goto_lsp_declarations, }) end, desc = 'In below window', },
    {'gDk', function() require("utils.window").run_in_above_window({ callback = require('utils.snacks').goto_lsp_declarations, }) end, desc = 'In above window', },
    {'gDl', function() require("utils.window").run_in_right_window({ callback = require('utils.snacks').goto_lsp_declarations, }) end, desc = 'In right window', },
    {'gDt', function() require("utils.tab").run_in_new_tab({ callback = require('utils.snacks').goto_lsp_declarations, }) end, desc = 'In new tab', },
  }

,
}
