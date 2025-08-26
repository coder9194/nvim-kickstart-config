vim.opt.showtabline = 2 -- Show tab line on start

return {
  'akinsho/bufferline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  opts = {
    highlights = {
      separator = {
        fg = '#908178',
      },
      buffer_selected = {
        bold = false,
        italic = false,
      },
      info_selected = {
        bold = false,
        italic = false,
      },
      warning_selected = {
        bold = false,
        italic = false,
      },
      error_selected = {
        bold = false,
        italic = false,
      },
      hint_selected = {
        bold = false,
        italic = false,
      },
      numbers_selected = {
        bold = false,
        italic = false,
      },
    },
    options = {
      mode = 'tabs',
      always_show_bufferline = true, -- Required in `tabs` mode to fix weird cursor auto jumping
      indicator = {
        style = 'none',
      },
      numbers = 'ordinal',
      show_duplicate_prefix = false,
      show_close_icon = false,
      show_buffer_close_icons = false,
      truncate_names = false,
      modified_icon = '',
      separator_style = { '|', '|' },
      name_formatter = function(buf)
        local current_tab_index = vim.api.nvim_tabpage_get_number(buf.tabnr)
        local tabpages = require('bufferline.tabpages').get()
        for _, tabpage in pairs(tabpages) do
          local tab_page_name = tabpage.component[2].text
          local tab_page_index = tabpage.id
          local is_tab_page_renamed = tab_page_name ~= ' ' .. tab_page_index .. ' '

          if tab_page_index == current_tab_index and is_tab_page_renamed then
            return tab_page_name
          end
        end
        return buf.name
      end,
    },
  },
}
