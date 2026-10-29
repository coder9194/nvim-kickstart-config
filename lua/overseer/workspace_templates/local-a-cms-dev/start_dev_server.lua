local TEMPLATE_NAME = "Start Dev Server"

return {
  name = TEMPLATE_NAME,
  builder = function()
    print("Dev server is starting")
    vim.g.__overseer_server_name = "Dev Server"

    return {
      name = TEMPLATE_NAME,
      cmd = "source ~/.zshrc && express-dev-server --project-name=local-a-cms-dev",
      components = { "handle_express_dev_server", "default", "unique" },
    }
  end,
}
