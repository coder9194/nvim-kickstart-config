return {
  -- Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'owner/repo',

  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  opts = {},

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  config = function()
    -- If you prefer to call `setup` explicitly, use:
    -- require('repo').setup(opts)
  end,

  -- Plugins can also be configured to run Lua code when they are loaded.
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  -- normal autocommands events (`:help autocmd-events`).
  event = 'VimEnter', -- which loads which-key before all the UI elements are loaded. Events can be

  -- Plugins can specify dependencies.
  -- Anything you do for a plugin at the top level, you can do for a dependency.
  -- Use the `dependencies` key to specify the dependencies of a particular plugin
  dependencies = {
    'owner/repo',
  },
}
