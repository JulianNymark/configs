return {
	{
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			-- require("mini.surround").setup() -- USING nvim.surround instead! (has more features)

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			require("mini.move").setup({
				mappings = {
					left = "H",
					right = "L",
					down = "J",
					up = "K",
					-- wack behaviour when tapping esc before hjkl?! (maybe a karabiner thing)
					-- seems to trigger <M-*> somehow? therefore disabling those here
					line_left = "",
					line_right = "",
					line_down = "",
					line_up = "",
				},
			})

			require("mini.operators").setup({
				evaluate = {
					prefix = "-=",
				},
				exchange = {
					prefix = "-x",
				},
				multiply = {
					prefix = "-m",
				},
				replace = {
					prefix = "-r",
				},
				sort = {
					prefix = "-s",
				},
			})

			-- NOTE: mini.surround seems not as powerful as nvim.surround
			-- require("mini.surround").setup({})
			-- still want a way to use tree-sitter for the {,(,[ matchers... (currently it matches on _any_, eg string contents...)
			-- I want to be able to distinguish between both, but usually I think I want code cognizant matches (so tree-sitter)

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			local surr = require("nvim-surround")
			local surr_utils = require("nvim-surround.config")
			surr.setup({
				-- Configuration here, or leave empty to use defaults
				aliases = {
					-- brackets, curly brackets, square brackets
					["b"] = { ")", "}", "]" },
				},
				surrounds = {
					-- CSS block
					["c"] = {
						add = function()
							local input = surr_utils.get_input("Enter a CSS selector: ")
							if input then
								return {
									{ input .. " {" },
									{
										"}",
									},
								}
							end
							return { { "" }, { "" } }
						end,
					},
				},
			})
		end,
	},
	{
		"cbochs/grapple.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		opts = {
			scope = "git_branch",
		},
		keys = {
			{ "<leader>fa", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
			{ "<c-e>", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },

			{ "<c-h>", "<cmd>Grapple select index=1<cr>", desc = "grapple 1" },
			{ "<c-t>", "<cmd>Grapple select index=2<cr>", desc = "grapple 2" },
			{ "<c-n>", "<cmd>Grapple select index=3<cr>", desc = "grapple 3" },
			{ "<c-s>", "<cmd>Grapple select index=4<cr>", desc = "grapple 4" },
			{ "<c-_>", "<cmd>Grapple select index=5<cr>", desc = "grapple 5" },

			{ "<c-s-n>", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
			{ "<c-s-p>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
		},
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "[u]ndotree" },
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
			require("nvim-autopairs").setup()
		end,
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
	},
	{
		"Wansmer/sibling-swap.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			use_default_keymaps = false,
			keymaps = {
				["<space>."] = "swap_with_right_with_opp",
				["<space>,"] = "swap_with_left_with_opp",
			},
		},
		config = function(_, opts)
			local swap = require("sibling-swap")
			swap.setup(opts)
			vim.keymap.set("n", "<leader>.", swap.swap_with_right_with_opp, { desc = "swap with right sibling" })
			vim.keymap.set("n", "<leader>,", swap.swap_with_left_with_opp, { desc = "swap with left sibling" })
		end,
	},
	-- The following configuration
	--  event = 'VimEnter'
	--
	-- which loads which-key before all the UI elements are loaded. Events can be
	-- normal autocommands events (`:help autocmd-events`).
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		config = function()
			local wk = require("which-key")
			wk.setup()

			-- Document existing key chains
			wk.add({
				{ "<leader>a", group = "[a]i" },
				{ "<leader>b", group = "[b]rowse" },
				{ "<leader>c", group = "[c]ode" },
				{ "<leader>d", group = "[d]ebug" },
				{ "<leader>f", group = "[f]ile" },
				{ "<leader>g", group = "[g]it" },
				{ "<leader>gl", group = "[l]ist" },
				{ "<leader>h", group = "Git [h]unk" },
				{ "<leader>n", group = "[n]oice" },
				{ "<leader>r", group = "[r]efactor" },
				{ "<leader>s", group = "[s]earch" },
				{ "<leader>t", group = "[t]oggle" },
				{ "<leader>w", group = "[w]orkspace" },
				{ "<leader><leader>", group = "utility" },
				{ "gr", group = "LSP" },
			})

			-- visual mode
			wk.add({
				{ "<leader>h", desc = "Git [h]unk" },
			}, { mode = "v" })
		end,
	},
	{
		-- BUG: a quick `gc` + slow `c` doesn't work, but slow `g`+`c`+`c` does, quick `gcc` does
		"numToStr/Comment.nvim",
		opts = {},
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			local comment = require("Comment")
			---@diagnostic disable-next-line: missing-fields
			comment.setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},
	{ "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	{
		"epwalsh/pomo.nvim",
		version = "*", -- Recommended, use latest release instead of latest commit
		-- cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
		dependencies = {
			-- Optional, but highly recommended if you want to use the "Default" timer
			"rcarriga/nvim-notify",
		},
		opts = {
			-- See below for full list of options 👇
		},
		config = function(_, opts)
			require("pomo").setup(opts)
			vim.keymap.set("n", "<leader>ps", "<cmd>TimerStart 25m Work<CR>", { desc = "[s]tart timer" })
			vim.keymap.set("n", "<leader>pS", "<cmd>TimerStop<CR>", { desc = "[S]top timer" })
			vim.keymap.set("n", "<leader>pp", "<cmd>TimerPause<CR>", { desc = "[p]ause timer" })
			vim.keymap.set("n", "<leader>pP", "<cmd>TimerResume<CR>", { desc = "[P]lay timer" })
		end,
	},
	{
		"andymass/vim-matchup",
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		-- TODO: harpoon2 doesn't seem to properly open files? (BufRead?)
		event = "BufRead",
		-- event = "VeryLazy",
		-- event = "FileType",
		opts = {},
		config = function()
			vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
			vim.opt.foldcolumn = "1" -- '0' is not bad
			vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.opt.foldenable = true
			vim.opt.foldlevelstart = 99

			require("ufo").setup()
		end,
	},
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		dependencies = {
			"folke/snacks.nvim",
		},
		keys = {
			{
				"<leader>bc",
				mode = { "n", "v" },
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
			{
				"<leader>b<leader>",
				"<cmd>Yazi cwd<cr>",
				desc = "Open the file manager in nvim's working directory",
			},
			{
				"<leader>br",
				"<cmd>Yazi toggle<cr>",
				desc = "Resume the last yazi session",
			},
		},
		opts = {
			open_for_directories = true,
			floating_window_scaling_factor = 1,
		},
		init = function()
			-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
			-- vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
	},
}
