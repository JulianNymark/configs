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

				function overrides(c, color)
					return {
						-- ["@text.diff.add"] = { link = "DiffAdd" },
						-- ["@text.diff.delete"] = { link = "DiffDelete" },
					}
				end

				fm.setup({
					glow = true,
					theme = "fluoromachine",
					transparent = true,
					overrides = overrides,
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
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			notifier = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
	},
}
