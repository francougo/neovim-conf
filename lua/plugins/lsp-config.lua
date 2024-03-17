return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
        -- Reference of LSPs
        -- https://github.com/williamboman/mason-lspconfig.nvim
          "lua_ls",
          "jsonls",
          "jdtls",
          "quick_lint_js",
          "cssls",
          "bashls",
          "ltex",
          "yamlls",
          "r_language_server",
          }
        })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      lspconfig.jdtls.setup({
        capabilities = capabilities
      })
      lspconfig.r_language_server.setup({
        capabilities = capabilities
      })

      vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, {})
      vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, {})
    end,
  }
}
