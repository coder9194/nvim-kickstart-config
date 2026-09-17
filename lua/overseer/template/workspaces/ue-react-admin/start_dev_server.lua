return {
  name = "Start Dev Server",
  builder = function()
    print("Dev server is starting")

    return {
      cmd = "source ~/.zshrc && nvm use 16 && npm install && npm start",
      components = { "default", "unique" },
    }
  end,
}
