local function get_default_template(task_name, port_number)
  return {
    name = task_name,
    builder = function()
      print("Metro is starting")

      return {
        name = task_name,
        cmd = "dotenv -- cross-var npm install && npx react-native start --reset-cache --port " .. port_number,
        components = { "handle_metro", "default", "unique" },
      }
    end,
  }
end

return get_default_template
