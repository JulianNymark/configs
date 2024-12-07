vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = ":Ex netrw [P]eruse [V]olumes (disk)" })
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch, { desc = "clear highlight search hits" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>q", "<cmd>copen<CR>", { desc = "Open quickfix list" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Go to next [q]uickfix item" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Go to previous [q]uickfix item" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set("n", "<C-d>", "<C-d>zz", { remap = false })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { remap = false })
-- vim.keymap.set("n", "<Leader>p", 'vi""*p', { desc = '[p]aste clipboard into ""' })

vim.api.nvim_create_user_command("JsonF", function()
	vim.cmd("%!jq .")
end, { nargs = 0 })

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selection [K] dir" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selection [J] dir" })
vim.keymap.set(
	"n",
	"<Leader>l",
	":let @+ = expand('%') . ':' . line('.')<cr>",
	{ desc = "Copy file:[L]ine_number to clipboard" }
)

-- TODO: this should be limited (not for q: command selection etc...)
-- vim.keymap.set("n", "<cr>", "@@")

local lc1 = "tab:» ,trail:·,space:·,nbsp:␣,eol:$"
local lc2 = "tab:  ,trail: ,nbsp: ,eol: "
function ChgListchars()
	if vim.o.listchars == lc1 then
		vim.opt.listchars = lc2
	else
		vim.opt.listchars = lc1
	end
end

vim.keymap.set("n", "<Leader>fs", ":w<CR>", { desc = "[s]ave" })
vim.keymap.set("n", "<Leader>fS", ":wa<CR>", { desc = "[S]ave all" })

-- enable marks for counted jumps
vim.keymap.set("n", "j", function()
	if vim.v.count > 1 then
		return "m'" .. vim.v.count .. "gj"
	end
	return "gj"
end, { remap = false, expr = true })
vim.keymap.set("n", "k", function()
	if vim.v.count > 1 then
		return "m'" .. vim.v.count .. "gk"
	end
	return "gk"
end, { remap = false, expr = true })

vim.keymap.set(
	"n",
	"<Leader><Leader>s",
	"<cmd>source ~/.config/nvim/lua/snippets.lua<CR>",
	{ desc = "[s]ource snippets" }
)

-- Noice
vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "[d]ismiss messages" })
vim.keymap.set("n", "<leader>sm", "<cmd>NoiceTelescope<CR>", { desc = "[m]essages" })

vim.keymap.set("n", "<leader>tt", "<cmd>Twilight<CR>", { desc = "[t]wilight (focus scope hl)" })
vim.keymap.set("n", "<Leader>t_", ChgListchars, { desc = "Toggle Whitespace (_) rendering" })
