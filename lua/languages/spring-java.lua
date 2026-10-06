return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts_extend = {
      'ensure_installed',
    },
    opts = {
      ensure_installed = {
        'jdtls', -- Java Language Server
        'java-test', -- Java Test Runner
        'java-debug-adapter', -- Java Debug Adapter
        'vscode-spring-boot-tools', -- Spring Boot Tools
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        jdtls = {
          settings = {
            java = {
              autobuild = {
                enabled = true,
              },
            },
          },
        },
      },
    },
  },
  {
    'nvim-java/nvim-java',
    dependencies = {
      {
        'JavaHello/spring-boot.nvim',
        version = '218c0c26',
      },
      'MunifTanjim/nui.nvim',
      'mfussenegger/nvim-dap',
    },
    config = function()
      local function get_vscode_ext_path(pkg_name)
        local base = vim.fn.stdpath 'data' .. '/mason/packages/' .. pkg_name
        if vim.fn.filereadable(base .. '/extension/package.json') == 1 then
          return base .. '/extension'
        end
        return base
      end

      local function get_lombok_path()
        local jdtls_lombok = vim.fn.stdpath 'data' .. '/mason/packages/jdtls/lombok.jar'
        if vim.fn.filereadable(jdtls_lombok) == 1 then
          return jdtls_lombok
        end
        return vim.fn.stdpath 'data' .. '/mason/share/jdtls/lombok.jar'
      end

      require('java').setup {
        jdk = {
          auto_install = false,
          path = vim.fn.expand '$JAVA_HOME',
        },
        jdtls = {
          auto_install = false,
          path = vim.fn.stdpath 'data' .. '/mason/packages/jdtls',
        },
        java_test = {
          auto_install = false,
          path = get_vscode_ext_path 'java-test',
        },
        java_debug_adapter = {
          auto_install = false,
          enable = false, -- TODO: enable this later after integration of nvim-dap
          path = get_vscode_ext_path 'java-debug-adapter',
        },
        spring_boot_tools = {
          auto_install = false,
          path = get_vscode_ext_path 'vscode-spring-boot-tools',
        },
        lombok = {
          auto_install = false,
          path = get_lombok_path(),
        },
      }
      vim.lsp.enable 'jdtls'
    end,
  },
}
