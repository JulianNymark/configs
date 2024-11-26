return {
	"stevearc/conform.nvim",
	lazy = false,
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>ff",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[f]ormat",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 500,
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
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
