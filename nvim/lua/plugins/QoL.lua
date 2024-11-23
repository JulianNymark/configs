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

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "[A]dd to harpoon list" })
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "[E]xplicate harpoon list" })

			vim.keymap.set("n", "<C-h>", function()
				harpoon:list():select(1)
			end, { desc = "[h] tns- = harpoon [1] 2345" })
			vim.keymap.set("n", "<C-t>", function()
				harpoon:list():select(2)
			end, { desc = "h [t] ns- = harpoon 1 [2] 345" })
			vim.keymap.set("n", "<C-n>", function()
				harpoon:list():select(3)
			end, { desc = "ht [n] s- = harpoon 12 [3] 45" })
			vim.keymap.set("n", "<C-s>", function()
				harpoon:list():select(4)
			end, { desc = "htn [s] - = harpoon 123 [4] 5" })
			vim.keymap.set("n", "<C-_>", function()
				harpoon:list():select(5)
			end, { desc = "htns [-] = harpoon 1234 [5]" })

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end, { desc = "[P]revious harpoon buffer" })
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end, { desc = "[N]ext harpoon buffer" })
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
	-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
	--
	-- This is often very useful to both group configuration, as well as handle
	-- lazy loading plugins that don't need to be loaded immediately at startup.
	--
	-- For example, in the following configuration, we use:
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
				{ "<leader>b", group = "[b]rowse" },
				{ "<leader>c", group = "[c]ode" },
				{ "<leader>d", group = "[d]ocument" },
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
				{ "<leader>h", desc = "Git [H]unk" },
			}, { mode = "v" })
		end,
	},
	{ "numToStr/Comment.nvim", opts = {} },
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
}
