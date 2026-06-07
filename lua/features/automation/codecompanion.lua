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
    strategies = {
      chat = {
        adapter = {
          name = 'copilot',
          model = 'gpt-5.4-mini',
        },
        placement = 'replace',
        diff = {
          enabled = false, -- Turn off the side-by-side window
        },
      },
      inline = {
        adapter = {
          name = 'copilot',
          model = 'gpt-5.4-mini',
        },
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
