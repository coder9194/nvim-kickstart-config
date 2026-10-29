return {
  name = "Start Dev Server",
  builder = function()
    print("Metro is starting")

    return {
      cmd = "dotenv -- cross-var yarn install && npx react-native start --reset-cache --port 8083",
      components = { "handle_metro", "default", "unique" },
    }
  end,
}
