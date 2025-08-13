local file_name = require("utils.lua").get_current_file_name()
local task_name = require("utils.lua").parse_title_case(file_name)
vim.print("task_name")
vim.print(task_name)

local android_build_template =
  require("overseer.template.common.react_native_android_build")("Start Android Build", 8082)

return android_build_template
