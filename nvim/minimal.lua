-- Don't forget:
-- rm -rf ~/Repos/configs/nvim/.nvim-minimal
-- before new plugin tests!
local root = vim.fn.expand("~/Repos/configs/nvim/.nvim-minimal")

for _, name in ipairs({ "config", "data", "state", "cache" }) do
	vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

local lazypath = root .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		-- some plugin
	},
}, {
	root = root .. "/plugins",
})
