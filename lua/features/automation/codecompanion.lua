return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'lalitmee/codecompanion-spinners.nvim',
    'mrjones2014/codecompanion-ui.nvim',
  },
  opts = {
    opts = {
      log_level = 'ERROR', -- use 'TRACE' if need extra debugging (e.g. requests, response, AI models)
    },
    adapters = {
      http = {
        qwen9b = function()
          return require('codecompanion.adapters').extend('ollama', {
            schema = {
              model = {
                default = 'qwen3.5:4b-mlx', -- Matches your exact model tag
              },
              num_ctx = {
                default = 16384, -- Adjust based on your memory comfort
              },
            },
          })
        end,
      },
    },
    strategies = {
      chat = {
        -- adapter = {
        --   name = 'copilot',
        --   model = 'gpt-5.4-mini',
        -- },
        adapter = 'qwen9b',
        placement = 'replace',
        diff = {
          enabled = false, -- Turn off the side-by-side window
        },
      },
      inline = {
        -- adapter = {
        --   name = 'copilot',
        --   model = 'gpt-5.4-mini',
        -- },
        adapter = 'qwen9b',
        -- This forces the AI to replace the text directly in the file
        placement = 'replace',
        diff = {
          enabled = false, -- Turn off the side-by-side window
        },
      },
    },
    extensions = {
      spinner = {
        enabled = true,
        opts = {
          style = 'snacks',
        },
      },
    },
  },
  keys = {
    { '<leader>aa', '<cmd>CodeCompanionActions<cr>', desc = 'CodeCompanion actions', mode = { 'n', 'v' } },
    { '<leader>at', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle AI Chat' },
  },
}
