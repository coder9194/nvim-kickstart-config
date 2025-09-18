return {
  {
    'folke/which-key.nvim',
    opts_extends = { 'spec' },
    opts = {
      spec = {
        { '<leader>wc', group = 'Copilot Chat' },
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = {
      window = {
        layout = 'float',
      },
      mappings = {
        reset = '', -- Disbale reset mapping on <c-l>
      },
    },
    -- stylua: ignore
    keys = {
      { '<leader>wcl', function() require('CopilotChat').open { window = { layout = 'vertical', }, } end, desc = 'Open in vertical split', },
      { '<leader>wcf', function() require('CopilotChat').open { window = { layout = 'float', }, } end, desc = 'Open in float window', },
      { '<leader>wcj', function() require('CopilotChat').open { window = { layout = 'horizontal', }, } end, desc = 'Open in horizontal split', },
    },
  },
}
