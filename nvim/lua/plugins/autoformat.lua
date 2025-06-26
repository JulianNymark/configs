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
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "[F]ormat without LSP",
    },
  },
  opts = {
    notify_on_error = false,
    stop_after_first = true,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local prefer_lsp = { c = true, cpp = true, lua = true }
      local function get_lsp_fallback()
        if prefer_lsp[vim.bo[bufnr].filetype] then
          return "prefer" -- soft "only LSP"
        end
        return "fallback" -- soft "no LSP" LSP "if nothing else"
      end
      return {
        timeout_ms = 500,
        stop_after_first = true,
        lsp_format = get_lsp_fallback(),
      }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettierd", "eslint", stop_after_first = true },
      javascriptreact = { "prettierd", "eslint", stop_after_first = true },
      typescript = { "prettierd", "eslint", stop_after_first = true },
      typescriptreact = { "prettierd", "eslint", stop_after_first = true },

      css = { "prettierd", "eslint", stop_after_first = true },
      scss = { "prettierd", "eslint", stop_after_first = true },
      json = { "prettierd", "eslint", stop_after_first = true },
      svelte = { "prettierd", "eslint", stop_after_first = true },
      graphql = { "prettierd", "eslint", stop_after_first = true },
      markdown = { "prettierd", "eslint", stop_after_first = true },
    },
  },
}
