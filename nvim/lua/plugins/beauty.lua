return {
	{
		"nyoom-engineering/oxocarbon.nvim",
		config = function()
			-- vim.cmd.colorscheme("oxocarbon")
		end,
	},
	{
		"ayu-theme/ayu-vim",
		config = function()
			-- vim.cmd.colorscheme("ayu")
		end,
	},
	{
		{
			"maxmx03/fluoromachine.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				local fm = require("fluoromachine")

				fm.setup({
					glow = true,
					theme = "fluoromachine",
					transparent = true,
				})

				vim.cmd.colorscheme("fluoromachine")
			end,
		},
	},
	{
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			-- vim.cmd.colorscheme("catppuccin-mocha")

			-- You can configure highlights by doing something like:
			-- vim.cmd.hi("Comment gui=none")
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
				hover = {
					silent = true,
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
}
