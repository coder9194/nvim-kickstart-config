local TEMPLATE_NAME = "Start Manager Dev Server"

return {
  name = TEMPLATE_NAME,
  builder = function()
    print("Dev server is starting")
    vim.g.__overseer_server_name = "Manager Dev Server"

    return {
      name = TEMPLATE_NAME,
      cmd = "source ~/.zshrc && express-dev-server --project-name=a-aetoshtml --account-type=manager",
      components = { "handle_express_dev_server", "default", "unique" },
    }
  end,
}
