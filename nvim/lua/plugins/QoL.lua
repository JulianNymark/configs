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
				replace = {
					prefix = "gp",
				},
			})

			-- ... and there is more!
			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			vim.keymap.set("n", "<leader>fa", function()
				harpoon:list():add()
			end, { desc = "[a]dd to harpoon list" })
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "[e]xplicate harpoon list" })

			vim.keymap.set("n", "<C-h>", function()
				harpoon:list():select(1)
			end, { desc = "harpoon 1" })
			vim.keymap.set("n", "<C-t>", function()
				harpoon:list():select(2)
			end, { desc = "harpoon 2" })
			vim.keymap.set("n", "<C-n>", function()
				harpoon:list():select(3)
			end, { desc = "harpoon 3" })
			vim.keymap.set("n", "<C-s>", function()
				harpoon:list():select(4)
			end, { desc = "harpoon 4" })
			vim.keymap.set("n", "<C-_>", function()
				harpoon:list():select(5)
			end, { desc = "harpoon 5" })

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end, { desc = "[P]revious harpoon buffer" })
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end, { desc = "[n]ext harpoon buffer" })
		end,
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
			})

			-- visual mode
			wk.add({
				{ "<leader>h", desc = "Git [h]unk" },
			}, { mode = "v" })
		end,
	},
	{ "numToStr/Comment.nvim", opts = {} },
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
}
