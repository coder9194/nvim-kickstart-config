---@param task_name string
---@param port_number number
local function get_default_template(task_name, port_number)
  return {
    name = task_name,
    builder = function()
      print("Android build is starting")

      return {
        name = task_name,
        cmd = "dotenv -- cross-var npx react-native run-android --mode=liveDebug --port " .. port_number,
        components = { "default", "unique" },
      }
    end,
  }
end

return get_default_template
