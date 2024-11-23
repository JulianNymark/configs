return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
		config = function(_, opts)
			local gitsigns = require("gitsigns")
			gitsigns.setup(vim.tbl_deep_extend("force", {
				on_attach = function(bufnr)
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end, { desc = "next [C]hange" })

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end, { desc = "prev [C]hange" })

					-- Actions
					map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "[h]unk [s]tage" })
					map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "[h]unk [r]eset" })
					map("v", "<leader>hs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "[h]unk [s]tage" })
					map("v", "<leader>hr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "[h]unk [r]eset" })
					map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "[h]unk [S]tage buffer" })
					map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "[h]unk [u]ndo" })
					map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "[h]unk [R]eset buffer" })
					map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "[h]unk [p]review hunk" })
					map("n", "<leader>hb", function()
						gitsigns.blame_line({ full = true })
					end, { desc = "[h]unk [b]lame line" })
					map(
						"n",
						"<leader>tb",
						gitsigns.toggle_current_line_blame,
						{ desc = "[t]oggle current [b]lame line" }
					)
					map("n", "<leader>hd", gitsigns.diffthis, { desc = "[h]unk [d]iffthis" })
					map("n", "<leader>hD", function()
						gitsigns.diffthis("~")
					end, { desc = "[h]unk [D]iffthis ~" })
					map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[t]oggle [d]eleted" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "gitsigns select_hunk" })
				end,
			}, opts))
		end,
	},
	{
		"tanvirtin/vgit.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function() -- This is the function that runs, AFTER loading
			local vgit = require("vgit")
			vgit.setup({})
			vim.keymap.set("n", "<C-k>", vgit.hunk_up, { desc = "hunk up" })
			vim.keymap.set("n", "<C-j>", vgit.hunk_down, { desc = "hunk down" })
			vim.keymap.set("n", "<leader>gs", vgit.buffer_hunk_stage, { desc = "buffer hunk [s]tage" })
			vim.keymap.set("n", "<leader>gr", vgit.buffer_hunk_reset, { desc = "buffer hunk [r]eset" })
			vim.keymap.set("n", "<leader>gp", vgit.buffer_hunk_preview, { desc = "buffer hunk [p]review" })
			vim.keymap.set("n", "<leader>gb", vgit.buffer_blame_preview, { desc = "buffer [b]lame preview" })
			vim.keymap.set("n", "<leader>gf", vgit.buffer_diff_preview, { desc = "buffer di[f]f preview" })
			vim.keymap.set("n", "<leader>gh", vgit.buffer_history_preview, { desc = "buffer hunk [h]istory preview" })
			vim.keymap.set("n", "<leader>gu", vgit.buffer_reset, { desc = "buffer [u]ndo all" })
			vim.keymap.set(
				"n",
				"<leader>gg",
				vgit.buffer_gutter_blame_preview,
				{ desc = "[g]utter buffer blame preview" }
			)
			vim.keymap.set("n", "<leader>glu", vgit.project_hunks_preview, { desc = "[u]nstaged" })
			vim.keymap.set("n", "<leader>gls", vgit.project_hunks_staged_preview, { desc = "[l]ist [s]taged" })
			vim.keymap.set("n", "<leader>gd", vgit.project_diff_preview, { desc = "[d]iff" })
			vim.keymap.set("n", "<leader>gq", vgit.project_hunks_qf, { desc = "[q]uickfix hunks" })
			vim.keymap.set("n", "<leader>gx", vgit.toggle_diff_preference, { desc = "toggle betwi[x]t diff pref" })
		end,
	},
}
