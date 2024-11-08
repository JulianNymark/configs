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
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set("n", "<C-d>", "<C-d>zz", { remap = false })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { remap = false })
vim.keymap.set("n", "<Leader>p", 'vi""*p', { desc = '[p]aste clipboard into ""' })

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

vim.keymap.set("n", ",", "@@")

local lc1 = "tab:» ,trail:·,space:·,nbsp:␣,eol:$"
local lc2 = "tab:  ,trail: ,nbsp: ,eol: "
function ChgListchars()
	if vim.o.listchars == lc1 then
		vim.opt.listchars = lc2
	else
		vim.opt.listchars = lc1
	end
end
vim.keymap.set("n", "<Leader>_", ChgListchars, { desc = "Toggle Whitespace (_) rendering" })
vim.keymap.set("n", "<Leader>fs", ":w<CR>", { desc = "[s]ave" })
