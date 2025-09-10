-- Lightweight floating statuslines, best used with Neovim's global statusline (set laststatus=3)
-- https://github.com/b0o/incline.nvim

vim.opt.winbar = ' ' -- Show empty winbar

return {
  'b0o/incline.nvim',
  event = 'VeryLazy',
  opts = {
    render = function(props)
      local function get_git_diff()
        local icons = { removed = ' ', changed = ' ', added = ' ' }
        local signs = vim.b[props.buf].gitsigns_status_dict
        local labels = {}
        if signs == nil then
          return labels
        end
        for name, icon in pairs(icons) do
          if tonumber(signs[name]) and signs[name] > 0 then
            table.insert(labels, { icon .. signs[name] .. ' ', group = 'Diff' .. name })
          end
        end
        if #labels > 0 then
          table.insert(labels, { '| ' })
        end
        return labels
      end

      local function get_filename()
        local file_full_path = require('utils.buffer').get_file_path(props.buf)
        local filename = vim.fn.fnamemodify(file_full_path, ':t')
        local parent_folder_name = vim.fn.fnamemodify(file_full_path, ':p:h:t')
        local displayed_filename = filename == '' and '[No Name]' or parent_folder_name .. '/' .. filename
        local ft_icon, ft_color = require('nvim-web-devicons').get_icon_color(filename)
        local modified = vim.bo[props.buf].modified
        return {
          ft_icon and { ft_icon, ' ', guibg = 'none', guifg = ft_color } or '',
          { displayed_filename },
          ' ',
          modified and { '' } or '',
        }
      end

      local function get_diagnostic_label()
        local icons = { error = ' ', warn = ' ', info = '󰋼 ', hint = ' ' }
        local label = {}

        for severity, icon in pairs(icons) do
          local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
          if n > 0 then
            table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity })
          end
        end
        if #label > 0 then
          table.insert(label, { '| ' })
        end
        return label
      end

      return {
        { get_diagnostic_label() },
        { get_git_diff() },
        { get_filename() },
      }
    end,
    hide = {
      cursorline = 'focused_win',
    },
    window = {
      zindex = 30,
      overlap = {
        winbar = true,
      },
    },
  },
}
