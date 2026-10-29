return {
  name = "Start Android Build",
  builder = function()
    print("Android build is starting")

    return {
      cmd = "dotenv -- cross-var npx react-native run-android --port 8083",
      components = { "default", "unique" },
    }
  end,
}
