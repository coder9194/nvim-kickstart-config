vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Allow image preview manually in file buffer',
  callback = function()
    if require('store.options').image_preview_enabled then
      require('store.options').image_preview_enabled = false
    elseif not require('store.options').image_preview_enabled then
      require('image').disable()
    end
  end,
})

-- This plugin adds image support to Neovim using Kitty's Graphics Protocol or ueberzugpp.
-- It works great with Kitty and Tmux, and it handles all the rendering complexity for you.
-- https://github.com/3rd/image.nvim
return {
  '3rd/image.nvim',
  opts = {
    backend = 'kitty', -- or "ueberzug" or "sixel"
    processor = 'magick_cli', -- or "magick_rock"
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        only_render_image_at_cursor_mode = 'popup', -- or "inline"
        floating_windows = false, -- if true, images will be rendered in floating markdown windows
        filetypes = { 'markdown', 'vimwiki' }, -- markdown extensions (ie. quarto) can go here
      },
      neorg = {
        enabled = true,
        filetypes = { 'norg' },
      },
      typst = {
        enabled = true,
        filetypes = { 'typst' },
      },
      html = {
        enabled = false,
      },
      css = {
        enabled = false,
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    scale_factor = 1.0,
    window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
    window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', 'snacks_notif', 'scrollview', 'scrollview_sign' },
    editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
    tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    -- NOTE: For SVG to work, ImageMagick must be built from source with the --with-rsvg option.
    hijack_file_patterns = { '*.svg' }, -- render image files as images when opened
  },
  -- stylua: ignore
  keys = {
    { '<leader>fi', desc = 'Preview Image', function() local file_path = require('utils.file').get_full_path() require('image').enable() require('image') .from_file(file_path, { id = 'my_image_id', window = 1000, buffer = 1000, with_virtual_padding = true, inline = true, x = 1, y = 1, width = 10, height = 10, }) :render() require('store.options').image_preview_enabled = true vim.defer_fn(require('utils.buffer').reload, 100) end, },
  },
}
