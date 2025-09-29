-- Copilot Chat
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
return {
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim', branch = 'master' },
  },
  build = 'make tiktoken',
  opts = {
    model = 'o4-mini',
    temperature = 0.1, -- Lower = focused, higher = creative
    window = {
      layout = 'float',
    },
    mappings = {
      reset = '', -- Disbale reset mapping on <c-l>
    },
  },
    -- stylua: ignore
    keys = {
      { '<leader>ac',  function () require('CopilotChat').open { window = { layout = 'float', } } end, desc = 'Copilot chat' },
      { '<leader>ac', mode = 'v', '<cmd>CopilotChat #selection<cr>', desc = 'Attach to Copilot' },
    },
}
