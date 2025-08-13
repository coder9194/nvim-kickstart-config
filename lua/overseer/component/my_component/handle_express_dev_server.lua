return {
  desc = "Handling of custom server project `express-dev-server`",
  constructor = function()
    return {
      on_output_lines = function(_, _, lines)
        local server_name = vim.g.__overseer_server_name or ""

        if require("utils.lua").contains_partly(lines, "Server is running on") then
          vim.g.__overseer_server_name = nil
          print(server_name .. " is ready")
        end
      end,
    }
  end,
}
