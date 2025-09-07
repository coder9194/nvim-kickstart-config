-- Color highlighter

return {
  'NvChad/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup {
      user_default_options = {
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = true, -- 0xAARRGGBB hex codes
      },
    }
  end,
}
