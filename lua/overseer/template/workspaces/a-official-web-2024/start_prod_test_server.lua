return {
  name = "Start Prod Test Server",
  builder = function()
    print("Prod test server is starting")

    return {
      cmd = "source ~/.zshrc && npm run build && npm run start",
      components = { "default", "unique" },
    }
  end,
}
