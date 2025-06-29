return {
  "stevearc/conform.nvim",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "<leader>ff",
      function()
        require("conform").format({ async = true, lsp_format = "prefer" })
      end,
      mode = "",
      desc = "[f]ormat",
    },
    {
      "<leader>fF",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "[F]ormat without LSP",
    },
  },
  opts = {
    notify_on_error = false,
    stop_after_first = true,
    lsp_format = "fallback",
    format_on_save = function(bufnr)
      return {
        timeout_ms = 500,
      }
    end,
    formatters_by_ft = {
      c = { lsp_format = "prefer" },
      cpp = { lsp_format = "prefer" },
      lua = { "stylua", lsp_format = "prefer" },

      javascript = { "prettierd", "eslint" },
      javascriptreact = { "prettierd", "eslint" },
      typescript = { "prettierd", "eslint" },
      typescriptreact = { "prettierd", "eslint" },

      css = { "prettierd", "eslint" },
      scss = { "prettierd", "eslint" },
      json = { "prettierd", "eslint", lsp_format = "prefer" },
      svelte = { "prettierd", "eslint" },
      graphql = { "prettierd", "eslint" },
      markdown = { "prettierd", "eslint" },
    },
  },
}
