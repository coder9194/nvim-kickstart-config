-- blink.cmp is a completion plugin with support for LSPs, cmdline, signature help, and snippets. It uses an optional custom fuzzy matcher for typo resistance. It provides extensibility via pluggable sources (LSP, buffer, snippets, etc), component based rendering and dynamic configuration.
-- Autocompletion
-- https://github.com/saghen/blink.cmp

return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        -- {
        --   'rafamadriz/friendly-snippets',
        --   config = function()
        --     require('luasnip.loaders.from_vscode').lazy_load()
        --   end,
        -- },
      },
      opts = {},
    },
    'folke/lazydev.nvim',
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      preset = 'default',
      ['<right>'] = { 'accept', 'fallback' },
      ['<tab>'] = { 'accept', 'fallback' },

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      keyword = { range = 'full' },
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
      menu = {
        draw = {
          -- Show where the completion came from (LSP, Path, Buffer)
          columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
        },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
    },

    sources = {
      default = {
        'lsp',
        'path',
        'buffer',
        'snippets',
        'lazydev',
      },
      providers = {
        lsp = {
          name = 'LSP',
          module = 'blink.cmp.sources.lsp',
          score_offset = 100, -- Prioritize smart compiler data over raw text words
          min_keyword_length = function(ctx)
            -- If the current active LSP client is tailwindcss, require 2 characters
            if ctx.client and ctx.client.name == 'tailwindcss' then
              return 2
            end
            return 0
          end,
        },
        path = {
          name = 'Path',
          module = 'blink.cmp.sources.path',
          score_offset = 50,
          opts = {
            trailing_slash = true,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.getcwd()
            end,
          },
        },
        buffer = {
          name = 'Buffer',
          module = 'blink.cmp.sources.buffer',
          score_offset = 0, -- Fallback to text matching if LSP doesn't know the word
        },
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See :h blink-cmp-config-fuzzy for more information
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  },
  -- stylua: ignore
  keys = {
    { '<c-c>', mode = 'n', function() require('utils.nvim').send_keys 'e' require('utils.nvim').send_keys 'a' require('blink.cmp').show() end, desc = 'Suggest Imports', },
    { '<c-c>', mode = 'i', function() require('blink.cmp').show() end, desc = 'Suggest Imports', },
  },
}
