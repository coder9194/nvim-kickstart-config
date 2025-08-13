return {
  name = "Start Dev Server",
  builder = function()
    print("Dev server is starting")

    return {
      cmd = "source ~/.zshrc && nvm use 16 && PORT=4001 npm start",
      components = { "default", "unique" },
    }
  end,
}
