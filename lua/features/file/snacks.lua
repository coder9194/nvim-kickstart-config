return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    picker = {
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
            ['<c-j>'] = { 'open_in_below', mode = { 'i', 'n' } },
            ['<c-k>'] = { 'open_in_above', mode = { 'i', 'n' } },
            ['<c-l>'] = { 'open_in_right', mode = { 'i', 'n' } },
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
        open_in_left = function(picker, item)
          local file_path = item._path

          Snacks.picker.actions.close(picker)
          require('utils.window').run_in_left_window {
            callback = function()
              vim.api.nvim_command('edit ' .. file_path)
            end,
          }
        end,
        open_in_below = function(picker, item)
          local file_path = item._path

          Snacks.picker.actions.close(picker)
          require('utils.window').run_in_below_window {
            callback = function()
              vim.api.nvim_command('edit ' .. file_path)
            end,
          }
        end,
        open_in_above = function(picker, item)
          local file_path = item._path

          Snacks.picker.actions.close(picker)
          require('utils.window').run_in_above_window {
            callback = function()
              vim.api.nvim_command('edit ' .. file_path)
            end,
          }
        end,
        open_in_right = function(picker, item)
          local file_path = item._path

          Snacks.picker.actions.close(picker)
          require('utils.window').run_in_right_window {
            callback = function()
              vim.api.nvim_command('edit ' .. file_path)
            end,
          }
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
