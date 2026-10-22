return {
  {
    'razak17/tailwind-fold.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'html', 'svelte', 'astro', 'vue', 'typescriptreact', 'php', 'blade' },
    config = function()
      require('tailwind-fold').setup()

      -- Force clear tailwind-fold's internal augroup to wipe duplicate BufEnter listeners
      vim.api.nvim_create_augroup('conceal_class_name', { clear = true })

      --------------------------------------------------------------------------------
      -- Handle show/hide of tailwind-fold customly to improve performance
      --------------------------------------------------------------------------------
      local tailwind_group = vim.api.nvim_create_augroup('TailwindFoldPerf', { clear = true })

      vim.api.nvim_create_autocmd('InsertEnter', {
        group = tailwind_group,
        desc = 'Disable tailwind fold when entering insert mode',
        callback = function()
          vim.cmd 'TailwindFoldDisable'
          require('utils.log').debug 'TailwindFoldDisable'
        end,
      })

      vim.api.nvim_create_autocmd('InsertLeave', {
        group = tailwind_group,
        desc = 'Enable tailwind fold when leaving insert mode',
        callback = function()
          vim.cmd 'TailwindFoldEnable'
          require('utils.log').debug 'TailwindFoldEnable'
        end,
      })

      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        desc = 'Toggle tailwind className fold when entering to / exiting from a diffview',
        pattern = '*',
        callback = function(ev)
          local is_diffview = require('utils.diffview').is_diffview_tab()
          require('utils.log').trace('is diffview: ' .. vim.inspect(is_diffview))

          if is_diffview then
            if vim.api.nvim_buf_is_valid(ev.buf) and vim.b[ev.buf].tailwind_folded then
              vim.b[ev.buf].tailwind_folded = false
              vim.cmd 'TailwindFoldDisable'
              require('utils.log').debug 'TailwindFoldDisable'
            end
          else
            if vim.api.nvim_buf_is_valid(ev.buf) and not vim.b[ev.buf].tailwind_folded then
              vim.b[ev.buf].tailwind_folded = true
              vim.cmd 'TailwindFoldEnable'
              require('utils.log').debug 'TailwindFoldEnable'
            end
          end

          -- local target_file_types = {
          --   html = true,
          --   svelte = true,
          --   astro = true,
          --   vue = true,
          --   typescriptreact = true,
          --   php = true,
          --   blade = true,
          -- }
          -- local is_target_filetype = target_file_types[vim.bo[ev.buf].filetype]
          -- if not is_target_filetype then
          --   return
          -- end
          --
          -- if vim.wo.diff then
          --   if vim.b[ev.buf].tailwind_folded then
          --     vim.cmd 'TailwindFoldDisable'
          --     require('utils.log').debug '🐱 TailwindFoldDisable'
          --     vim.b[ev.buf].tailwind_folded = false
          --   end
          --   return
          -- end
          --
          -- -- 4. State-tracked, deferred folding logic
          -- local is_normal_mode = vim.api.nvim_get_mode().mode == 'n'
          -- local is_small_file = vim.api.nvim_buf_line_count(ev.buf) <= 1000
          --
          -- if is_normal_mode and is_small_file then
          --   -- IDEMPOTENCY CHECK: Only run if the buffer is NOT already folded
          --   if not vim.b[ev.buf].tailwind_folded then
          --     if vim.api.nvim_buf_is_valid(ev.buf) then
          --       vim.cmd 'TailwindFoldEnable'
          --       require('utils.log').debug '🐱 TailwindFoldEnable'
          --       vim.b[ev.buf].tailwind_folded = true
          --     end
          --   end
          -- else
          --   if vim.b[ev.buf].tailwind_folded then
          --     vim.cmd 'TailwindFoldDisable'
          --     require('utils.log').debug '🐱 TailwindFoldDisable'
          --     vim.b[ev.buf].tailwind_folded = false
          --   end
          -- end
        end,
      })
    end,
  },
  {
    'ruicsh/tailwindcss-dial.nvim',
    dependencies = { 'monaqa/dial.nvim' },
    opts = {
      -- group = "default", -- optional, defaults to "default"
      -- ft = { "typescriptreact", "astro" }, -- optional
    },
    -- stylua: ignore
    keys = {
      { mode = 'n', '<C-a>', function() require('dial.map').manipulate('increment', 'normal') end, { desc = 'Increment Target' }, },
      { mode = 'n', '<C-x>', function() require('dial.map').manipulate('decrement', 'normal') end, { desc = 'Decrement Target' }, },
      { mode = 'v', '<C-a>', function() require('dial.map').manipulate('increment', 'visual') end, { desc = 'Increment Target' }, },
      { mode = 'v', '<C-x>', function() require('dial.map').manipulate('decrement', 'visual') end, { desc = 'Decrement Target' }, },
    },
  },
  {
    'ruicsh/tailwind-hover.nvim',
    keys = {
      { '<leader><s-k>', '<cmd>TailwindHover<cr>', desc = 'Tailwind: Hover' },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {},
  },
  {
    'ruicsh/tailwindcss-shades.nvim',
    opts = {},
  },
}
