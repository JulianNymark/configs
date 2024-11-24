return {
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
