local M = {}

local find_root_query = ''
local find_root_cursor = nil

local find_target_query = ''
local find_target_cursor = nil

local grep_root_query = ''
local grep_root_cursor = nil

local grep_target_query = ''
local grep_target_cursor = nil

local last_target_dir = ''
local history = {}

-- Helper to find directories relative to project root
local function get_project_dirs(lead)
  local root = Snacks.git.get_root() or vim.uv.cwd()
  local search_pattern = root .. '/' .. (lead or '') .. '*'
  local raw_matches = vim.fn.glob(search_pattern, false, true)

  local results = {}
  for _, full_path in ipairs(raw_matches) do
    if vim.fn.isdirectory(full_path) == 1 then
      local rel_path = vim.fs.relpath(root, full_path)
      if rel_path and rel_path ~= '' and rel_path ~= '.' then
        table.insert(results, rel_path .. '/')
      end
    end
  end
  return results
end

-- Shared input prompt for target directory selection
local function prompt_target_dir(on_select)
  local root = Snacks.git.get_root() or vim.uv.cwd()
  local hist_idx = #history + 1

  Snacks.input({
    prompt = 'Search in directory (empty to current directory): ',
    default = last_target_dir,
    win = {
      on_buf = function(win)
        local buf = win and win.buf or vim.api.nvim_get_current_buf()

        -- Enable blink.cmp on this buffer with only the project_dirs provider
        vim.b[buf].blink_cmp_enabled = true
        vim.b[buf].blink_cmp_sources = { 'project_dirs' }

        -- History Navigation in Normal Mode ('k' = older, 'j' = newer)
        vim.keymap.set('n', 'k', function()
          if #history == 0 then
            return
          end
          hist_idx = math.max(1, hist_idx - 1)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, { history[hist_idx] })
        end, { buffer = buf, nowait = true })

        vim.keymap.set('n', 'j', function()
          if #history == 0 then
            return
          end
          if hist_idx < #history then
            hist_idx = hist_idx + 1
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, { history[hist_idx] })
          else
            hist_idx = #history + 1
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, { '' })
          end
        end, { buffer = buf, nowait = true })

        vim.schedule(function()
          vim.cmd 'stopinsert'
        end)
      end,
    },
  }, function(target_directory)
    if not target_directory then
      return
    end

    if target_directory ~= '' and history[#history] ~= target_directory then
      table.insert(history, target_directory)
    end

    last_target_dir = target_directory

    local effective_dir
    if target_directory == '' or target_directory == '.' then
      effective_dir = vim.fn.expand '%:p:h'
    else
      effective_dir = vim.fs.normalize(root .. '/' .. target_directory)
    end

    on_select(effective_dir)
  end)
end

-- Find files in root directory
function M.find_files_in_root()
  local root = Snacks.git.get_root() or vim.uv.cwd()
  local is_cursor_restored = false

  Snacks.picker.smart {
    cwd = root,
    pattern = find_root_query,
    on_change = function(picker)
      if not is_cursor_restored and find_root_cursor and picker.list and #picker.list.items > 0 then
        is_cursor_restored = true
        vim.schedule(function()
          picker.list:view(find_root_cursor)
        end)
      end
    end,
    on_close = function(picker)
      find_root_query = (picker.input and picker.input.filter and picker.input.filter.pattern) or (picker.filter and picker.filter.pattern) or ''

      if picker.list and picker.list.cursor then
        find_root_cursor = picker.list.cursor
      end
    end,
  }
end

-- Find files in target directory
function M.find_files_in_path()
  prompt_target_dir(function(effective_dir)
    local is_cursor_restored = false

    Snacks.picker.smart {
      cwd = effective_dir,
      pattern = find_target_query,
      on_change = function(picker)
        if not is_cursor_restored and find_target_cursor and picker.list and #picker.list.items > 0 then
          is_cursor_restored = true
          vim.schedule(function()
            picker.list:view(find_target_cursor)
          end)
        end
      end,
      on_close = function(picker)
        find_target_query = (picker.input and picker.input.filter and picker.input.filter.pattern) or (picker.filter and picker.filter.pattern) or ''

        if picker.list and picker.list.cursor then
          find_target_cursor = picker.list.cursor
        end
      end,
    }
  end)
end

-- Find files by grep in root directory
function M.grep_in_root()
  local root = Snacks.git.get_root() or vim.uv.cwd()
  local is_cursor_restored = false

  Snacks.picker.grep {
    cwd = root,
    search = grep_root_query,
    on_change = function(picker)
      if not is_cursor_restored and grep_root_cursor and picker.list and #picker.list.items > 0 then
        is_cursor_restored = true
        vim.schedule(function()
          picker.list:view(grep_root_cursor)
        end)
      end
    end,
    on_close = function(picker)
      grep_root_query = picker:filter().search

      if picker.list and picker.list.cursor then
        grep_root_cursor = picker.list.cursor
      end
    end,
  }
end

-- Find files by grep in target directory
function M.grep_in_path()
  prompt_target_dir(function(effective_dir)
    local is_cursor_restored = false

    Snacks.picker.grep {
      cwd = effective_dir,
      search = grep_target_query,
      on_change = function(picker)
        if not is_cursor_restored and grep_target_cursor and picker.list and #picker.list.items > 0 then
          is_cursor_restored = true
          vim.schedule(function()
            picker.list:view(grep_target_cursor)
          end)
        end
      end,
      on_close = function(picker)
        grep_target_query = picker:filter().search

        if picker.list and picker.list.cursor then
          grep_target_cursor = picker.list.cursor
        end
      end,
    }
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
