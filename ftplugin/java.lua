-- This is not the language server, this is a plugin to enhance the
-- LSP installed and managed by mason
-- Check for documentation: https://github.com/mfussenegger/nvim-jdtls
local cmd = { "/path/to/jdt-language-server/bin/jdtls" }
local data_dir = vim.fn.stdpath("data") .. "/"
local jdtls_dir = data_dir .. "mason/packages/jdtls/"
local config_dir = jdtls_dir .. "config_linux"
local plugins_dir = jdtls_dir .. "plugins/"
local lombok_file = jdtls_dir .. "lombok.jar"
local jar_file = plugins_dir .. "org.eclipse.equinox.launcher_1.6.700.v20231214-2017.jar"
--                              change version after updates  ^^^^^^^^^^^^^^^^^^^^^^
-- This is the default, the jdtls needs to find which is the root of the project
-- this is done by finding some files or directories as the ones below
local root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1])

-- Unique directory for each project where eclipse saves cache files
-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
-- So always cd into the project directory before starting neovim 
-- TODO implement some better way of creating and recognizing project names
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = data_dir .. "site/java/workspace-root/" .. project_name
-- is this necessary?
-- os.execute("mkdir " .. workspace_dir)

local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {

		"/usr/bin/java", -- java version must be >= 17

		-- Options from the documentation, i don't know what they are
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
    "-javaagent:" .. lombok_file,
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",

		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",

		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		"-jar",
		jar_file,

		"-configuration",
		config_dir,

		"-data",
		workspace_dir,
	},

	root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      home = '/Users/ivanermolaev/Library/Java/JavaVirtualMachines/temurin-18.0.1/Contents/Home/',
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-18",
            path = "/Users/ivanermolaev/Library/Java/JavaVirtualMachines/temurin-18.0.1/Contents/Home",
          },
          {
            name = "JavaSE-17",
            path = "/Users/ivanermolaev/Library/Java/JavaVirtualMachines/temurin-17.0.4/Contents/Home",
          }
        }
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      format = {
        enabled = true,
        settings = {
          url = vim.fn.stdpath "config" .. "/lang-servers/intellij-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },

    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      importOrder = {
        "java",
        "javax",
        "com",
        "org"
      },
    },
    extendedClientCapabilities = extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },

  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    bundles = {},
  },
}

require('jdtls').start_or_attach(config)
