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

        require('image').enable()
        require('image').clear()
        show_svg_preview()
      end,
      -- Disable temp
      -- on_close = function()
      --   require('image').clear()
      --   require('image').disable()
      --   vim.defer_fn(require('utils.buffer').reload, 100)
      -- end,
      sources = {
        files = {
          ignored = true, -- Ignore files in .gitignore
          hidden = true, -- Show hidden files
          exclude = {
            -- Manual list of excluded folders
            '.git',
            '.next',
            'node_modules',
            'worktrees',
          },
        },
        smart = {
          multi = { 'files' },
        },
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
        open_in_floating_win = function(picker, item)
          -- 1. Catch the target file path safely
          local target_file = nil
          if item then
            target_file = item.file or item.text
          else
            target_file = vim.api.nvim_get_current_line()
          end

          if not target_file or target_file == '' then
            print 'No valid file reference captured.'
            return
          end

          -- Extract target coordinates from LSP picker selection
          local target_pos = item and item.pos or nil

          -- Close the active picker frame to clear the viewport layer
          picker:close()

          -- 2. Format path title as: "directory/file_name.format"
          local parent_dir = vim.fn.fnamemodify(target_file, ':p:h:t')
          local file_name = vim.fn.fnamemodify(target_file, ':t')
          local formatted_title = string.format(' %s/%s ', parent_dir, file_name)

          -- 3. Check if the buffer already exists globally to prevent E95 collision error
          local buf_id = vim.fn.bufnr(target_file)
          if buf_id == -1 then
            -- File is not open anywhere else; create and name a new buffer safely
            buf_id = vim.api.nvim_create_buf(false, false)
            vim.api.nvim_buf_set_name(buf_id, target_file)
          end

          -- 4. Launch the window using our verified buffer target
          local float_win = Snacks.win {
            buf = buf_id,
            width = 0.85,
            height = 0.85,
            border = 'rounded',
            title = formatted_title,
            title_pos = 'center',
            zindex = 60,
            wo = {
              number = true,
              relativenumber = true,
              signcolumn = 'yes',
            },
            bo = {
              buflisted = true,
            },
          }

          -- 5. Trigger buffer file rendering and execute position jumping securely
          if float_win and float_win.win and vim.api.nvim_win_is_valid(float_win.win) then
            vim.api.nvim_win_call(float_win.win, function()
              -- Synchronously ensure the file content is fully drawn inside the canvas frame
              vim.fn.bufload(buf_id)
              vim.cmd 'edit!'

              -- Apply cursor coordinate alignments
              if target_pos then
                local line = target_pos[1] or 1
                local col = target_pos[2] or 0
                pcall(vim.api.nvim_win_set_cursor, 0, { line, col })
                vim.cmd 'normal! zz'
              end
            end)
          end

          -- 6. "Watch Destination" WinEnter system to close the float upon focus loss
          if float_win and float_win.win then
            local float_win_id = float_win.win

            vim.api.nvim_create_autocmd('WinEnter', {
              callback = function()
                -- If the float window was already closed manually by the user, destroy this listener
                if not float_win or not float_win:valid() then
                  return true
                end

                local current_win = vim.api.nvim_get_current_win()

                -- If our cursor lands back in the floating window, do nothing
                if current_win == float_win_id then
                  return
                end

                local current_buf = vim.api.nvim_get_current_buf()
                local buftype = vim.api.nvim_buf_get_option(current_buf, 'buftype')
                local filetype = vim.api.nvim_buf_get_option(current_buf, 'filetype')

                -- If our cursor landed inside a nested picker window, protect the parent float
                if buftype == 'nofile' or filetype:find 'snacks_picker' then
                  return
                end

                -- If our cursor landed anywhere else (a normal code pane, tree sidebar, etc.), close the float!
                float_win:close()
                return true -- Kill this specific autocommand listener cleanly
              end,
            })
          end
        end,
      },
      win = {
        input = {
          keys = {
            ['<c-h>'] = { 'open_in_left', mode = { 'i', 'n' } },
            ['<c-j>'] = { 'edit_split', mode = { 'i', 'n' } },
            ['<c-k>'] = { 'open_in_above', mode = { 'i', 'n' } },
            ['<c-l>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
            ['<C-f>'] = { 'open_in_floating_win', mode = { 'n', 'i' } },
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
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>fr', function() require('snacks').rename.rename_file() end, desc = 'Rename File', },
{ '<leader>ff', mode = 'n', function() Snacks.picker.resume({ source = "smart" }) end, desc = 'Find Files (Smart Resume)', },
    { '<leader>fF', mode = 'n', require('utils.snacks').find_files_in_path, desc = 'Find Files (Target)' },
    { '<leader>fg', function() Snacks.picker.resume({ source = "grep" }) end, desc = 'Grep Files', },
    { '<leader>fG', function() require('utils.snacks').grep_in_path() end, desc = 'Grep Files (Target)', },
    { '<leader>fl', function() Snacks.picker.resume({ source = "lines" }) vim.cmd.stopinsert() end, desc = 'Find file lines', },
    { '<leader>fv', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' },
    },
  },
}
