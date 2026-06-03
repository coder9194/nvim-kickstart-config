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
        -- Workaround for the `top_p` error, ref: https://github.com/olimorris/codecompanion.nvim/issues/2884#issuecomment-4207100934
        copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
            -- https://codecompanion.olimorris.dev/configuration/adapters-http#changing-adapter-schema
            schema = {
              top_p = {
                ---@type fun(self: CodeCompanion.HTTPAdapter): boolean | boolean
                enabled = function(self)
                  local model = self.schema.model.default
                  if model:find '5.4' then
                    return false
                  end
                  return true
                end,
              },
            },
          })
        end,
      },
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
