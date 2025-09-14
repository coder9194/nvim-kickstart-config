local M = {}

-- Find files in target directory
function M.find_files_in_path()
  local target_directory = vim.fn.input 'Search in directory: '

  require('snacks').picker.files { cwd = target_directory }
end

-- Find files bu grep in target directory
function M.grep_in_path()
  local target_directory = vim.fn.input 'Search in directory: '

  require('snacks').picker.grep { cwd = target_directory }
end

-- Custom LSP definitions goto function to avoid reusing window
function M.goto_lsp_definitions()
  require('snacks.picker').lsp_definitions { jump = { reuse_win = false } }
end

-- Custom LSP declarations goto function to avoid reusing window
function M.goto_lsp_declarations()
  require('snacks.picker').lsp_declarations { jump = { reuse_win = false } }
end

-- Custom LSP implementations goto function to avoid reusing window
function M.goto_lsp_implementations()
  require('snacks.picker').lsp_implementations { jump = { reuse_win = false } }
end

-- Custom LSP type definitions goto function to avoid reusing window
function M.goto_lsp_type_definitions()
  require('snacks.picker').lsp_type_definitions { jump = { reuse_win = false } }
end

-- Custom LSP references goto function to avoid reusing window
function M.goto_lsp_references()
  require('snacks.picker').lsp_references { jump = { reuse_win = false } }
end

return M
