-- NOTE: Pair here includes the bracket, quote and tag
return {
  -- Auto pair function (e.g. add closing bracket)
  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    opts = {},
    config = function(_, opts)
      require('ultimate-autopair').setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        desc = 'Disable autopair in picker input',
        pattern = 'snacks_picker_input',
        callback = function(ev)
          local pairs = { '(', '[', '{', '"', "'", '`', '<' }
          for _, key in ipairs(pairs) do
            vim.keymap.set('i', key, key, { buffer = ev.buf, nowait = true })
          end
        end,
      })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
      -- Also override individual filetype configs, these take priority.
      -- Empty by default, useful if one of the "opts" global settings
      -- doesn't work well in a specific filetype
      per_filetype = {
        ['html'] = {
          enable_close = false,
        },
      },
    },
  },
}
