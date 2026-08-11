return {
  {
    'razak17/tailwind-fold.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'html', 'svelte', 'astro', 'vue', 'typescriptreact', 'php', 'blade' },
    config = function()
      require('tailwind-fold').setup()

      -- Force clear tailwind-fold's internal augroup to wipe duplicate BufEnter listeners
      vim.api.nvim_create_augroup('conceal_class_name', { clear = true })

      -- Handle show/hide of tailwind-fold customly to improve performance
      local tailwind_group = vim.api.nvim_create_augroup('TailwindFoldPerf', { clear = true })
      vim.api.nvim_create_autocmd('InsertEnter', {
        group = tailwind_group,
        callback = function()
          vim.cmd 'TailwindFoldDisable'
        end,
      })
      vim.api.nvim_create_autocmd('InsertLeave', {
        group = tailwind_group,
        callback = function()
          vim.cmd 'TailwindFoldEnable'
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
