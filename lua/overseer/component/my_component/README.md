# Custom Components of overseer.nvim

## Introduction

Custom components are custom handling which can be reused in templates, for example:

```lua
-- template.lua
return {
  name = "Template sample",
  builder = function()
    return {
      cmd = "command",
      components = { "custom_component", "default", "unique" },
    }
  end,
}
```

More information:
<https://github.com/stevearc/overseer.nvim/blob/master/doc/guides.md#custom-components>

## Add new custom component

1. Create a lua file under `lua/overseer/component/my_component/`
2. Register the component in `lua/plugins/overseer-nvim.lua`

## Known Issues

- `params` is not working in custom components.
  - Use `vim.g.__overseer_global_variable` as workaround
