local M = {}

local last_directories = {
  smart = nil,
  grep = nil,
}

function get_relative_directory()
  local root = Snacks.git.get_root() or vim.uv.cwd()
  local current_directory = vim.fn.expand '%:p:h'
  local relative_directory = vim.fs.relpath(root, current_directory) or '.'

  return relative_directory
end

-- Find files in target directory
function M.find_files_in_path()
  local relative_directory = get_relative_directory()

  Snacks.input({
    prompt = 'Search in directory: ',
    default = last_directories.smart or relative_directory .. '/',
  }, function(target_directory)
    last_directories.smart = target_directory
    Snacks.picker.smart { cwd = target_directory }
  end)
end

-- Find files bu grep in target directory
function M.grep_in_path()
  local relative_directory = get_relative_directory()

  Snacks.input({
    prompt = 'Search in directory: ',
    default = last_directories.grep or relative_directory .. '/',
  }, function(target_directory)
    last_directories.grep = target_directory
    Snacks.picker.grep { cwd = target_directory }
  end)
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
