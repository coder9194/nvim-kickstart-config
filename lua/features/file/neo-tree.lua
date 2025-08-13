-- Neovim plugin to manage the file system and other tree like structures.
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons', -- optional, but recommended
  },
  opts = {
    event_handlers = {
      -- enter input popup with normal mode by default.
      {
        event = 'neo_tree_popup_input_ready',
        handler = function()
          vim.cmd 'stopinsert'
        end,
      },
      -- map <esc> to enter normal mode (by default closes prompt)
      {
        event = 'neo_tree_popup_input_ready',
        ---@param args { bufnr: integer, winid: integer }
        handler = function(args)
          -- don't forget `opts.buffer` to specify the buffer of the popup.
          vim.keymap.set('i', '<esc>', vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
        end,
      },
    },
    popup_border_style = 'rounded',
    window = {
      -- stylua: ignore
      mappings = {
        ['l'] = 'open',
        ['h'] = 'close_node',
        ['s'] = function() require('flash').jump() end,
        ['<c-h>'] = 'open_leftabove_vs',
        ['<c-j>'] = 'open_split',
        ['<c-k>'] = require('utils.neo-tree').open_file_in_above,
        ['<c-l>'] = 'open_vsplit',
        ['<c-t>'] = 'open_tab_drop',
      },
    },
    filesystem = {
      filtered_items = {
        visible = true,
      },
      follow_current_file = {
        enabled = true,
      },
      window = {
        position = 'float',
        mappings = {
          ['F'] = 'filter_on_submit',
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { mode = "n", "<leader>fe", require("utils.neo-tree").reveal_tree, desc = "Explorer (from opened)", },
    { mode = "n", "<leader>fE", function() require("neo-tree.command").execute({ position = "float" }) end, desc = "Explorer", },
  },
}
