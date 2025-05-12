return {
	{
		"zk-org/zk-nvim",
		-- "juliannymark/zk-nvim",
		-- branch = "add-some-guards",

		config = function()
			require("zk").setup({
				picker = "telescope",
			})
		end,
	},
}
