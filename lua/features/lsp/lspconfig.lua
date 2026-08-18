-- nvim-lspconfig is a "data only" repo, providing basic, default Nvim LSP client configurations for various LSP servers. View all configs or :help lspconfig-all from Nvim.
-- Main LSP Configuration
-- https://github.com/neovim/nvim-lspconfig
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    -- { 'mason-org/mason.nvim', opts = {} },
    { 'mason-org/mason.nvim' },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Allows extra capabilities provided by blink.cmp
    'saghen/blink.cmp',
  },
  event = 'VimEnter',
  opts = {
    servers = {
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`ts_ls`) will work just fine
      -- ts_ls = {},
      --

      lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
            hint = {
              enable = true,
              setType = true,
              paramName = 'All',
              paramType = true,
              await = true,
              arrayIndex = 'Enable',
            },
          },
        },
      },
      -- vtsls = require 'features.lsp.configs.vtsls',
      jdtls = {
        settings = {
          java = {
            autobuild = {
              enabled = false,
            },
          },
        },
      },
      eslint = {
        on_attach = function(client, bufnr)
          -- Disable eslint formatting if using other formatter like prettier
          client.server_capabilities.documentFormattingProvider = false

          vim.api.nvim_create_autocmd('BufWritePre', {
            desc = 'Eslint fix all on save',
            buffer = bufnr,
            callback = function()
              local clients = vim.lsp.get_clients { bufnr = 0 }
              if #clients == 0 then
                return
              end

              local position_encoding = clients[1].offset_encoding or 'utf-16'
              local params = vim.lsp.util.make_range_params(nil, position_encoding)
              ---@diagnostic disable-next-line: inject-field
              params.context = { only = { 'source.fixAll' } }

              local results = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
              for _, res in pairs(results or {}) do
                for _, action in pairs(res.result or {}) do
                  if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, position_encoding)
                  end
                  if action.command then
                    clients[1]:exec_cmd(action.command)
                  end
                end
              end
            end,
          })
        end,
      },
      jsonls = {},
      tailwindcss = {
        settings = {
          tailwindCSS = {
            -- Disables continuous line linting (rely on ESLint/Biome instead)
            validate = false,
            lint = {
              cssConflict = 'warning',
              invalidApply = 'error',
              invalidScreen = 'error',
              invalidVariant = 'error',
              invalidConfigPath = 'error',
            },
            experimental = {
              classRegex = {}, -- Leave empty unless using custom class wrappers (e.g., cva, clsx)
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    local servers = opts.servers or {}

    ---@type MasonLspconfigSettings
    ---@diagnostic disable-next-line: missing-fields
    require('mason-lspconfig').setup {
      automatic_enable = vim.tbl_keys(servers or {}),
    }

    -- Installed LSPs are configured and enabled automatically with mason-lspconfig
    -- The loop below is for overriding the default configuration of LSPs with the ones in the servers table
    for server_name, config in pairs(servers) do
      vim.lsp.config(server_name, config)
    end

    -- NOTE: Some servers may require an old setup until they are updated. For the full list refer here: https://github.com/neovim/nvim-lspconfig/issues/3705
    -- These servers will have to be manually set up with require("lspconfig").server_name.setup{}
  end,
  keys = {
    { '<leader>li', mode = 'n', '<cmd>:checkhealth vim.lsp<cr>', desc = 'Check LSP Info' },
    { '<leader>lr', mode = 'n', '<cmd>lsp restart<cr>', desc = 'Restart LSP' },
  },
}
