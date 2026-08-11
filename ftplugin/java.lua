local jdtls = require 'jdtls'

-- 1. Identify Project Root (detect Gradle wrapper / Android build files)
local root_markers = { 'gradlew', 'build.gradle', 'build.gradle.kts', '.git' }
local root_dir = jdtls.setup.find_root(root_markers)

if not root_dir or root_dir == '' then
  return
end

-- 2. Create Unique Workspace Directory per Project
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/site/java-workspace/' .. project_name

-- 3. Resolve JDTLS Executable path installed by Mason
local jdtls_bin = vim.fn.stdpath 'data' .. '/mason/bin/jdtls'

-- 4. Build Configuration
local config = {
  cmd = {
    jdtls_bin,
    '-data',
    workspace_dir,
    -- Prevent Eclipse metadata (.project, .settings) from polluting your project root
    '--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false',
    -- Give JDTLS sufficient memory for Android Gradle project indexing
    '-Xmx4G',
  },
  root_dir = root_dir,
  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          'org.hamcrest.MatcherAssert.assertThat',
          'org.hamcrest.Matchers.*',
          'org.junit.Assert.*',
          'org.mockito.Mockito.*',
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
      },
      -- Configure SDK runtimes if needed
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-17',
            path = vim.fn.expand '$JAVA_HOME',
          },
        },
      },
    },
  },
  -- Enable extended LSP capabilities
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

-- 5. Attach JDTLS
jdtls.start_or_attach(config)
