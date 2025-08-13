local M = {}

-- Lua version of `Array.reduce()` in Javascript
function M.reduce(table, callback_fn, initial_value)
  local accumulator = initial_value

  for current_index, current_value in ipairs(table) do
    accumulator = callback_fn(accumulator, current_value, current_index, table)
  end

  return accumulator
end

-- Lua version of `String.split()` in Javascript
function M.split_string(string, separator)
  local strings = {}
  -- Append a separator to handle the last segment
  local pattern = '([^' .. separator .. ']+)'

  for matched_string in string:gmatch(pattern) do
    table.insert(strings, matched_string)
  end

  return strings
end

-- Concatenate tables into a table
-- e.g. concatenate_tables({1, 2}, {3, 4}) => {1, 2, 3, 4}
function M.concatenate_tables(...)
  local tables = {}

  for _, table in ipairs { ... } do
    for i = 1, #table do
      tables[#tables + 1] = table[i] -- Append each element of the current table to result
    end
  end

  return tables
end

-- Check for existence of a value in a table
function M.contains(table, target)
  for _, table_value in ipairs(table) do
    if table_value == target then
      return true
    end
  end

  return false
end

-- Check for existence of a value in a table partly
function M.contains_partly(table, target)
  for _, table_value in ipairs(table) do
    if string.find(table_value, target) then
      return true
    end
  end

  return false
end

-- Remove table array item by matching any item value
function M.remove_table_item_by_value(target_table, value_to_remove)
  for i = #target_table, 1, -1 do
    for _, v in ipairs(target_table[i]) do
      if v == value_to_remove then
        table.remove(target_table, i)
        break -- Exit the inner loop after deleting
      end
    end
  end
end

-- Get full path of current file (where code exists)
function M.get_current_file_path()
  local info = debug.getinfo(1, 'S')
  local full_path = info.source:sub(2)

  return full_path
end

-- Get current file name (where code exists)
function M.get_current_file_name()
  local current_file_path = M.get_current_file_path()
  local current_file_name = current_file_path:match '([^/\\]+)$'

  return current_file_name
end

-- Parse snake_case to Title Case
---@param from_snake_string string
function M.parse_title_case(from_snake_string)
  -- Split the string by underscores
  local words = {}
  for word in string.gmatch(from_snake_string, '([^_]+)') do
    -- Capitalize the first letter and append to the words table
    local capitalized_word = word:sub(1, 1):upper() .. word:sub(2):lower()
    table.insert(words, capitalized_word)
  end
  -- Join the words with a space
  return table.concat(words, ' ')
end

return M
