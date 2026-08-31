return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    config = function()
      vim.o.cmdheight = 0 -- Hide command line when not being used

      require('lualine').setup {
        -- Refresh rate
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
        options = {
          globalstatus = true, -- enable global single statusline at neovim bottom
        },

        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = { 'filename' },

          -- 2. Inject the custom search component into your preferred section
          lualine_x = { require('utils.lualine').search_result, 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      }
    end,
  },
}
