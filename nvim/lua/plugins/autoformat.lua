return {
  "stevearc/conform.nvim",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function(_, opts)
    local conform = require("conform")
    conform.setup(opts)
    vim.keymap.set(
      "n",
      "<leader>ff",
      function()
        conform.format({ async = true, lsp_format = "prefer" })
      end,
      { desc = "[f]ormat" }
    )

    vim.keymap.set(
      "n",
      "<leader>fF",
      function()
        conform.format({ async = true, lsp_format = "fallback" })
      end,
      { desc = "[F]ormat without LSP" }
    )
  end,
  opts = {
    notify_on_error = false,
    stop_after_first = true,
    lsp_format = "fallback",
    format_on_save = function(bufnr)
      return {
        timeout_ms = 500,
      }
    end,
    formatters = {
      gdformat = {
        prepend_args = { "--use-spaces=4", "--line-length=75" }
      }
    },
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

      gdscript = { "gdformat" }
    },
  },
}
