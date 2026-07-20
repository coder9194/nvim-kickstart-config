-- Plugin to help utilize capabilities of vtsls
-- https://github.com/yioneko/nvim-vtsls
return {
  'yioneko/nvim-vtsls',
  enabled = false,
  config = function()
    require('vtsls').config {
      refactor_auto_rename = true,
    }
  end,
}
