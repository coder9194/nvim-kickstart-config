return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    picker = {
      -- Start picker in normal mode
      on_show = function()
        vim.cmd.stopinsert()
        require('image').enable()
      end,
      on_change = function(picker)
        local function show_svg_preview()
          local current_item = picker:current()

          if current_item and current_item.file then
            local ext = string.match(current_item.file, '%.([^%.]+)$')
            if ext == 'svg' then
              require('image').from_file(current_item.file):render {
                x = 130,
                y = 24,
                width = 24,
                height = 24,
              }
            end
          end
        end

        require('image').clear()
        show_svg_preview()
      end,
      on_close = function()
        require('image').disable()
        vim.defer_fn(require('utils.buffer').reload, 100)
      end,
      sources = {
        files = {
          ignored = true, -- Ignore files in .gitignore
          hidden = true, -- Show hidden files
          exclude = {
            -- Manual list of excluded folders
            '.git',
            '.next',
            'node_modules',
          },
        },
        smart = {
          multi = { 'files' },
        },
      },
      win = {
        input = {
          keys = {
            ['<c-h>'] = { 'open_in_left', mode = { 'i', 'n' } },
            ['<c-j>'] = { 'edit_split', mode = { 'i', 'n' } },
            ['<c-k>'] = { 'open_in_above', mode = { 'i', 'n' } },
            ['<c-l>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
            ['<CR>'] = { 'confirm_without_reuse', mode = { 'n', 'i' } },
          },
        },
      },
      jump = {
        reuse_win = false,
      },
      filter = {
        cwd = true, -- Search only on current workspace
      },
      actions = {
        open_in_left = function(picker, selected_file, actions)
          picker:action 'edit_vsplit'
          require('utils.window').swap_windows 'left'
        end,
        open_in_above = function(picker, item)
          picker:action 'edit_split'
          require('utils.window').swap_windows 'up'
        end,
        confirm_without_reuse = function(picker, item)
          local target_wins = function()
            local targets = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              local cfg = vim.api.nvim_win_get_config(win)
              if (vim.bo[buf].buflisted and cfg.relative == '') or vim.bo[buf].ft == 'snacks_dashboard' then
                local file = vim.api.nvim_buf_get_name(buf)
                table.insert(targets, { win = win, buf = buf, file = file })
              end
            end
            return targets
          end

          local targets = target_wins()

          for _, targ in ipairs(targets) do
            if targ.file == item.file or vim.bo[targ.buf].ft == 'snacks_dashboard' then
              picker.opts.jump.reuse_win = false --[[Override]]
              picker:action 'jump'
              return
            end
          end

          picker:action 'confirm'
        end,
      },
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>fr', function() require('snacks').rename.rename_file() end, desc = 'Rename File', },
    { '<leader>ff', mode = 'n', function() Snacks.picker.smart() end, desc = 'Find Files', },
    { '<leader>fF', mode = 'n', require('utils.snacks').find_files_in_path, desc = 'Find Files (Target)' },
    { '<leader>fg', function() Snacks.picker.grep() end, desc = 'Grep Files', },
    { '<leader>fG', function() require('utils.snacks').grep_in_path() end, desc = 'Grep Files (Target)', },
    { '<leader>fl', function() Snacks.picker.lines() end, desc = 'Find file lines', },
    { '<leader>fv', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' },
    },
  },
}
