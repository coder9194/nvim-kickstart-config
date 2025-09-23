local M = {}

--- Get the current active tab name
--- @return string|nil The name of the current active tab, or nil if not found
function M.get_current_tab_name()
  local ok, tabpages = pcall(require, 'bufferline.tabpages')
  if not ok then
    return nil
  end

  local tabs = tabpages.get()
  if not tabs then
    return nil
  end

  -- Find the selected tab by looking for BufferLineTabSelected highlight
  for _, tab in ipairs(tabs) do
    if tab.component then
      for _, component in ipairs(tab.component) do
        if component.highlight == 'BufferLineTabSelected' and component.text then
          return vim.trim(component.text)
        end
      end
    end
  end

  return nil
end

return M
