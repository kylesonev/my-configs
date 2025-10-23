return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- Python
      python = { "black", "isort" },

      -- JavaScript/TypeScript
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },

      -- Web
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },

      -- Lua
      lua = { "stylua" },

      -- Shell
      sh = { "shfmt" },
      bash = { "shfmt" },

      -- Go
      go = { "gofmt", "goimports" },

      -- Rust
      rust = { "rustfmt" },

      -- C/C++
      c = { "clang_format" },
      cpp = { "clang_format" },

      -- SQL
      sql = { "sql_formatter" },

      -- XML
      xml = { "xmlformat" },

      -- PHP
      php = { "php_cs_fixer" },

      -- Ruby
      ruby = { "rubocop" },

      -- Java
      java = { "google-java-format" },
    },

    -- Configurações específicas de formatters
    formatters = {
      -- Prettier com configurações customizadas
      prettier = {
        prepend_args = { "--tab-width", "2", "--single-quote" },
      },

      -- Black com line length customizado
      black = {
        prepend_args = { "--line-length", "88" },
      },

      -- Stylua (já vem configurado por padrão)
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
    },
  },
}
