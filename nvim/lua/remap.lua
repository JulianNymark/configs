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

local function git_sharelink_prefix()
	local function is_git_repo()
		local is_repo = vim.fn.system("git rev-parse --is-inside-work-tree")

		return vim.v.shell_error == 0
	end

	local function verify_git_branch(branch_name)
		local is_repo = vim.fn.system("git rev-parse --verify " .. branch_name)

		return vim.v.shell_error == 0
	end

	if not is_git_repo() then
		return ""
	end

	local raw_url = vim.fn.system("git remote get-url origin")

	local processed_url = raw_url:gsub("^.-@", ""):gsub(":", "/"):gsub("%.git", "")

	local main_branch_name = verify_git_branch("master") and "master" or "main"

	return processed_url .. "/blob/" .. main_branch_name .. "/"
end

-- TODO: make this not pollute the history (treat as one del + paste operation?)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selection [K] dir" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selection [J] dir" })

-- line sharing
vim.keymap.set("n", "<Leader>l", function()
	local line_link = vim.fn.expand("%") .. "#L" .. vim.fn.line(".")
	local share_link = git_sharelink_prefix() .. line_link

	vim.fn.setreg("*", share_link) -- send to the clipboard
end, { desc = "Copy file:[L]ine_number to clipboard" })
vim.keymap.set("v", "<Leader>l", function()
	-- press the esc key to leave visual mode
	local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "x", false) -- it's blocking == the best! (incredibly predictable)

	local l_from = vim.fn.getpos("'<")[2]
	local l_to = vim.fn.getpos("'>")[2]

	local file_link = vim.fn.expand("%")
	local line_link = file_link .. "#L" .. l_from .. "-L" .. l_to
	local share_link = git_sharelink_prefix() .. line_link

	vim.fn.setreg("*", share_link) -- send to the clipboard
end, { desc = "Copy file:[L]ine_number to clipboard" })

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

-- Notifications
vim.keymap.set("n", "<leader>nd", function()
	Snacks.notifier.hide()
end, { desc = "[d]ismiss messages" })
vim.keymap.set("n", "<leader>sm", function()
	Snacks.notifier.show_history()
end, { desc = "[m]essages" })

vim.keymap.set("n", "<leader>tt", "<cmd>Twilight<CR>", { desc = "[t]wilight (focus scope hl)" })
vim.keymap.set("n", "<Leader>t_", ChgListchars, { desc = "Toggle Whitespace (_) rendering" })
