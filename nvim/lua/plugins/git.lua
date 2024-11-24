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

					gitsigns.toggle_current_line_blame()

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
					map("n", "<leader>hp", gitsigns.preview_hunk_inline, { desc = "[h]unk [p]review hunk" })
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
}
