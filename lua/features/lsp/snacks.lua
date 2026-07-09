return {
  'folke/snacks.nvim',
  opts = {
    picker = {
      actions = {
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
            ['<C-f>'] = { 'open_in_floating_win', mode = { 'n', 'i' } },
          },
        },
      },
    },
  },
  -- stylua: ignore
  keys={
    { 'gd', function() require('snacks.picker').lsp_definitions { auto_confirm = false } end, desc = 'LSP Definitions', },
    { 'gi', function() require('snacks.picker').lsp_implementations { auto_confirm = false } end, desc = 'LSP Implementations', },
    { 'gr', function() require('snacks.picker').lsp_references { auto_confirm = false } end, desc = 'LSP References', },
    { 'gy', function() require('snacks.picker').lsp_type_definitions { auto_confirm = false } end, desc = 'LSP Type Definitions', },
    { 'gD', function() require('snacks.picker').lsp_declarations { auto_confirm = false } end, desc = 'LSP Declarations', },
  },
}
