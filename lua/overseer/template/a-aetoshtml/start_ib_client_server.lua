local TEMPLATE_NAME = "Start IB Client Dev Server"

return {
  name = TEMPLATE_NAME,
  builder = function()
    print("Dev server is starting")
    vim.g.__overseer_server_name = "IB Client Dev Server"

    return {
      name = TEMPLATE_NAME,
      cmd = "source ~/.zshrc && express-dev-server --project-name=a-aetoshtml --account-type=ib-client",
      components = { "handle_express_dev_server", "default", "unique" },
    }
  end,
}
