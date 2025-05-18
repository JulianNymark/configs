return {
	{
		"zk-org/zk-nvim",
		branch = "fix/client-nil-error",

		config = function()
			require("zk").setup({
				picker = "telescope",
			})
		end,
	},
}
