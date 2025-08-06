return {
  'mbbill/undotree',
  -- stylua: ignore
  keys = {
    { '<leader>fu', function() vim.cmd 'UndotreeToggle' vim.cmd 'UndotreeFocus' end, desc = 'File Undo Tree', },
  },
}
