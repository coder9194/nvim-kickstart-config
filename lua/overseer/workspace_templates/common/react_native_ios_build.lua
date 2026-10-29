local function get_default_template(task_name, port_number)
  return {
    name = task_name,
    builder = function()
      print("iOS build is starting")

      return {
        name = task_name,
        cmd = "dotenv -- cross-var npx pod-install && npx react-native run-ios --port " .. port_number,
        components = { "default", "unique" },
      }
    end,
  }
end

return get_default_template
