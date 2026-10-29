return {
  name = "Start iOS Build",
  builder = function()
    print("iOS build is starting")

    return {
      cmd = "dotenv -- cross-var npx pod-install && npx react-native run-ios --port 8083",
      components = { "default", "unique" },
    }
  end,
}
