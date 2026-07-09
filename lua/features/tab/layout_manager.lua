-- Ensure data path exists and define layout file name
local data_dir = vim.fn.stdpath 'data'
local data_path = data_dir .. '/layout_setups.json'

-- Create data directory if it doesn't exist yet to prevent file I/O drops
if vim.fn.isdirectory(data_dir) == 0 then
  vim.fn.mkdir(data_dir, 'p')
end

local saved_setups = {}

--- Load layouts from the local storage file on startup
local function load_persisted_setups()
  local file = io.open(data_path, 'r')
  if not file then
    saved_setups = {}
    return
  end
  local content = file:read '*a'
  file:close()

  if content and content ~= '' then
    local success, decoded = pcall(vim.json.decode, content)
    if success and decoded then
      saved_setups = decoded
    else
      saved_setups = {}
    end
  end
end

--- Flush the current in-memory layouts out to the persistent storage file
local function save_persisted_setups()
  local file = io.open(data_path, 'w')
  if file then
    local success, encoded = pcall(vim.json.encode, saved_setups)
    if success and encoded then
      file:write(encoded)
    end
    file:close()
  end
end

--- Recursively capture window geometry, layouts, and open file buffers
local function capture_layout(layout_node, total_w, total_h)
  local type = layout_node[1]

  if type == 'leaf' then
    local win_id = layout_node[2]
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local buf_name = vim.api.nvim_buf_get_name(buf_id)
    local buf_type = vim.api.nvim_get_option_value('buftype', { buf = buf_id })

    return {
      type = 'leaf',
      buf_name = buf_name,
      buf_type = buf_type,
      w_ratio = vim.api.nvim_win_get_width(win_id) / total_w,
      h_ratio = vim.api.nvim_win_get_height(win_id) / total_h,
    }
  else
    local children = {}
    for _, child in ipairs(layout_node[2]) do
      table.insert(children, capture_layout(child, total_w, total_h))
    end
    return {
      type = type,
      children = children,
    }
  end
end

--- Reconstruct the structural split grid tree cleanly by pre-allocating window frames
local function build_split_tree(node, win_id, win_list)
  if node.type == 'leaf' then
    table.insert(win_list, {
      win_handle = win_id,
      data = node,
    })
    return
  end

  -- Step 1: Pre-allocate windows for all children at this specific layout level
  local level_handles = { win_id }
  for _ = 2, #node.children do
    -- Always split from the last created window slice at this level
    vim.api.nvim_set_current_win(level_handles[#level_handles])
    if node.type == 'row' then
      vim.cmd 'rightbelow vsplit'
    else
      vim.cmd 'rightbelow split'
    end
    table.insert(level_handles, vim.api.nvim_get_current_win())
  end

  -- Step 2: Recurse into each child using its completely isolated window handle
  for i, child in ipairs(node.children) do
    build_split_tree(child, level_handles[i], win_list)
  end
end

--- Save setup layout hook
local function save_layout()
  local total_w = vim.o.columns
  local total_h = vim.o.lines

  local raw_layout = vim.fn.winlayout()
  local processed_layout = capture_layout(raw_layout, total_w, total_h)

  vim.ui.input({ prompt = 'Enter name for this window setup: ' }, function(name)
    if not name or name == '' then
      return
    end
    saved_setups[name] = processed_layout
    save_persisted_setups()
    print('Saved layout setup: ' .. name)
  end)
end

--- Open choice picker hook
local function open_picker()
  local has_snacks, Snacks = pcall(require, 'snacks')
  if not has_snacks then
    print 'Snacks.nvim is required for this configuration.'
    return
  end

  local items = {}
  for name, data in pairs(saved_setups) do
    table.insert(items, {
      text = name,
      layout_data = data,
    })
  end

  if #items == 0 then
    print 'No saved window setups found.'
    return
  end

  Snacks.picker.pick {
    source = 'Window Setups',
    items = items,
    prompt = 'Select Window Setup ',
    format = 'text',
    layout = 'select',
    actions = {
      confirm = function(picker, item)
        picker:close()
        if item and item.layout_data then
          local current_w = vim.o.columns
          local current_h = vim.o.lines

          local save_equalalways = vim.o.equalalways
          vim.o.equalalways = false

          -- Clear existing windows in the current active tab view frame
          local cur_win = vim.api.nvim_get_current_win()
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if win ~= cur_win and vim.api.nvim_win_is_valid(win) then
              pcall(vim.api.nvim_win_close, win, true)
            end
          end

          -- Pass 1: Build the split layout grid structure passing the base window context
          local target_windows = {}
          build_split_tree(item.layout_data, vim.api.nvim_get_current_win(), target_windows)

          -- Pass 2: Fill buffers and distribute sizes cleanly across collected handles
          for _, win_node in ipairs(target_windows) do
            local win = win_node.win_handle
            local data = win_node.data

            if vim.api.nvim_win_is_valid(win) then
              if data.buf_name and data.buf_name ~= '' then
                vim.api.nvim_win_call(win, function()
                  if data.buf_type == 'terminal' then
                    -- Re-open a clean terminal buffer instance if saved node was a terminal
                    vim.cmd 'terminal'
                  else
                    vim.cmd('edit ' .. vim.fn.fnameescape(data.buf_name))
                  end
                end)
              end

              local target_w = math.floor(data.w_ratio * current_w)
              local target_h = math.floor(data.h_ratio * current_h)

              pcall(vim.api.nvim_win_set_width, win, math.max(target_w, 2))
              pcall(vim.api.nvim_win_set_height, win, math.max(target_h, 2))
            end
          end

          vim.o.equalalways = save_equalalways
          print('Applied layout setup: ' .. item.text)
        end
      end,
      rename_setup = function(picker, item)
        if not item then
          return
        end
        vim.ui.input({ prompt = "Rename '" .. item.text .. "' to: ", default = item.text }, function(new_name)
          if not new_name or new_name == '' or new_name == item.text then
            return
          end
          saved_setups[new_name] = item.layout_data
          saved_setups[item.text] = nil
          save_persisted_setups()
          picker:close()
          open_picker()
        end)
      end,
      delete_setup = function(picker, item)
        if not item then
          return
        end
        saved_setups[item.text] = nil
        save_persisted_setups()
        picker:close()
        open_picker()
        print('Deleted setup: ' .. item.text)
      end,
    },
    win = {
      input = {
        keys = {
          ['r'] = { 'rename_setup', mode = { 'n' } },
          ['d'] = { 'delete_setup', mode = { 'n' } },
        },
      },
    },
  }
end

-- Load records explicitly from directory paths
load_persisted_setups()

-- Bound operational hotkeys
vim.keymap.set('n', '<leader>tls', save_layout, { desc = 'Save tab layout' })
vim.keymap.set('n', '<leader>tlr', open_picker, { desc = 'Restore tab layout' })

return {}
