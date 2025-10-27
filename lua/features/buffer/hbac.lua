-- Automagically close the unedited buffers in your bufferlist when it becomes too long. The "edited" buffers remain untouched. For a buffer to be considered edited it is enough to enter insert mode once or modify it in any way.
-- https://github.com/axkirillov/hbac.nvim
return {
  'axkirillov/hbac.nvim',
  opts = {
    autoclose = true, -- set autoclose to false if you want to close manually
    threshold = 10, -- hbac will start closing unedited buffers once that number is reached
    close_command = function(bufnr)
      vim.api.nvim_buf_delete(bufnr, {})
    end,
    close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
    telescope = {
      -- See #telescope-configuration below
    },
  },
}
