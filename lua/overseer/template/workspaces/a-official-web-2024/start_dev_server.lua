return {
  name = "Start Dev Server",
  builder = function()
    print("Dev server is starting")

    return {
      cmd = "source ~/.zshrc && npm install && npm run dev",
      components = { "default", "unique" },
    }
  end,
}
