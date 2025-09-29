local M = {}

--- Get the current active tab name
--- @return string|nil The name of the current active tab, or nil if not found
function M.get_current_tab_name()
  local ok, tabpages = pcall(require, 'bufferline.tabpages')
  if not ok or type(tabpages) ~= 'table' then
    return nil
  end

  if type(tabpages.get) ~= 'function' then
    return nil
  end

  local success, tabs = pcall(tabpages.get)
  if not success or type(tabs) ~= 'table' then
    return nil
  end

  -- Find the selected tab by looking for BufferLineTabSelected highlight
  for _, tab in ipairs(tabs) do
    local components = tab.component
    if type(components) == 'table' then
      for _, component in ipairs(components) do
        if component and component.highlight == 'BufferLineTabSelected' and component.text then
          return vim.trim(component.text)
        end
      end
    end
  end

  return nil
end

return M
