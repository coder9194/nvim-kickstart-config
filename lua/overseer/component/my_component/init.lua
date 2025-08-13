-- This file is called by `/lua/plugins/overseer-nvim.lua`

require("overseer").register_alias("handle_metro", { "default", "my_component.handle_metro" })
require("overseer").register_alias("handle_express_dev_server", { "default", "my_component.handle_express_dev_server" })
