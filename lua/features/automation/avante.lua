return {
  -- https://github.com/yetone/avante.nvim
  'yetone/avante.nvim',
  -- enabled = false,
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- this file can contain specific instructions for your project
    instructions_file = 'avante.md',
    provider = 'copilot',
    providers = {
      copilot = {
        -- No endpoint needed
        model = 'gpt-5-mini',
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'folke/snacks.nvim', -- for input provider snacks
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>aa', function() local tab_name = 'Avante Ask' require('utils.buffer').open_buffer_in_new_tab() vim.cmd 'AvanteChatNew' require('bufferline').rename_tab { tab_name } vim.defer_fn(function() require('utils.avante').set_tab_keymaps(tab_name) end, 100) end, desc = 'Ask Avante', },
    { '<leader>aS', '<cmd>AvanteStop<cr>', desc = 'Stop Avante' },
  },
}
