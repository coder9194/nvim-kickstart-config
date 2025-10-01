return {
  'olimorris/codecompanion.nvim',
  -- enabled = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    -- NOTE: The log_level is in `opts.opts`
    opts = {
      log_level = 'ERROR', -- use 'TRACE' if need extra debugging (e.g. requests, response, AI models)
    },
    strategies = {
      chat = {
        adapter = {
          name = 'copilot',
          model = 'gpt-5-mini',
        },
      },
    },
    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = 'Prompt ', -- Prompt used for interactive LLM calls
        provider = 'snacks', -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
        opts = {
          show_default_actions = true, -- Show the default actions in the action palette?
          show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          title = 'CodeCompanion actions', -- The title of the action palette
        },
      },
    },
  },
  keys = {
    { '<leader>aa', '<cmd>CodeCompanionActions<cr>', desc = 'CodeCompanion actions' },
  },
}
