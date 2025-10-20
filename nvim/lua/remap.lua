vim.g.mapleader = " "
vim.opt.hlsearch = true

local map = vim.keymap.set

-- scroll_and_recenter: A robust, flicker-free function for scrolling inside tmux.
-- It calculates the final state and executes it as a single atomic command.
-- @param direction string: "down" or "up"
local function scroll_and_recenter(direction)
  -- 1. Calculate how many lines to scroll
  local scroll_amount = vim.wo.scroll
  if scroll_amount == 0 then
    scroll_amount = math.floor(vim.api.nvim_win_get_height(0) / 2)
  end

  -- 1. Get the current window and cursor position
  local line_count = vim.api.nvim_buf_line_count(0)
  local win = 0                                        -- 0 is the current window
  local current_pos = vim.api.nvim_win_get_cursor(win) -- returns {row, col}
  local col = current_pos[2]                           -- Keep the same column
  local new_row = current_pos[1]

  if direction == "down" then
    new_row = new_row + scroll_amount
  elseif direction == "up" then
    new_row = new_row - scroll_amount
  else
    return -- Do nothing if the direction is invalid
  end

  -- clamp within buffer
  new_row = math.max(1, math.min(line_count, new_row))

  vim.api.nvim_win_set_cursor(win, { new_row, col })
  vim.cmd("normal! zz")
end

-- Create the keymaps using the new function
vim.keymap.set("n", "<C-d>", function() scroll_and_recenter("down") end, {
  noremap = true,
  silent = true,
  desc = "Scroll down",
})

vim.keymap.set("n", "<C-u>", function() scroll_and_recenter("up") end, {
  noremap = true,
  silent = true,
  desc = "Scroll up",
})

map("n", "<Esc>", vim.cmd.nohlsearch, { desc = "clear highlight search hits" })
map("n", "[d",
  function()
    vim.diagnostic.jump({ count = -1, float = true })
    vim.cmd("normal! zz")
  end, { desc = "Go to previous [d]iagnostic message" })
map("n", "]d",
  function()
    vim.diagnostic.jump({ count = 1, float = true })
    vim.cmd("normal! zz")
  end, { desc = "Go to next [d]iagnostic message" })
-- map("n", "<leader>De", vim.diagnostic.open_float, { desc = "Show diagnostic [e]rror messages" })
-- map("n", "<leader>Dq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
map("n", "<leader>q", "<cmd>copen<CR>", { desc = "Open [q]uickfix list" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next [q]uickfix item (recentered)" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous [q]uickfix item (recentered)" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- map("n", "<Leader>p", 'vi""*p', { desc = '[p]aste clipboard into ""' })

vim.api.nvim_create_user_command("JsonF", function()
  vim.cmd("%!jq .")
end, { nargs = 0 })

local function git_sharelink_prefix()
  local function is_git_repo()
    local _ = vim.fn.system("git rev-parse --is-inside-work-tree")

    return vim.v.shell_error == 0
  end

  local function verify_git_branch(branch_name)
    local _ = vim.fn.system("git rev-parse --verify " .. branch_name)

    return vim.v.shell_error == 0
  end

  if not is_git_repo() then
    return ""
  end

  local raw_url = vim.fn.system("git remote get-url origin"):gsub("\n", "")
  local processed_url = raw_url:gsub("^.-@", ""):gsub(":", "/"):gsub("%.git", "")
  local main_branch_name = verify_git_branch("master") and "master" or "main"

  return processed_url .. "/blob/" .. main_branch_name .. "/"
end

-- line sharing
map("n", "<Leader>fl", function()
  local line_link = vim.fn.expand("%") .. "#L" .. vim.fn.line(".")
  local share_link = git_sharelink_prefix() .. line_link

  vim.fn.setreg("*", share_link) -- send to the clipboard
end, { desc = "Copy [f]ile & [l]ine_number to clipboard" })
map("v", "<Leader>fl", function()
  -- press the esc key to leave visual mode
  local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false) -- it's blocking == the best! (incredibly predictable)

  local l_from = vim.fn.getpos("'<")[2]
  local l_to = vim.fn.getpos("'>")[2]

  local file_link = vim.fn.expand("%")
  local line_link = file_link .. "#L" .. l_from .. "-L" .. l_to
  local share_link = git_sharelink_prefix() .. line_link

  vim.fn.setreg("*", share_link) -- send to the clipboard
end, { desc = "Copy file & [l]ine_number to clipboard" })

-- TODO: this should be limited (not for q: command selection etc...)
-- map("n", "<cr>", "@@")

local lc1 = "tab:» ,trail:·,space:·,nbsp:␣,eol:$"
local lc2 = "tab:  ,trail: ,nbsp: ,eol: "
function ChgListchars()
  if vim.o.listchars == lc1 then
    vim.opt.listchars = lc2
  else
    vim.opt.listchars = lc1
  end
end

map("n", "<Leader>fs", ":w<CR>", { desc = "[s]ave" })
map("n", "<Leader>fS", ":wa<CR>", { desc = "[S]ave all" })

-- enable marks for counted jumps
map("n", "j", function()
  if vim.v.count > 1 then
    return "m'" .. vim.v.count .. "gj"
  end
  return "gj"
end, { remap = false, expr = true })
map("n", "k", function()
  if vim.v.count > 1 then
    return "m'" .. vim.v.count .. "gk"
  end
  return "gk"
end, { remap = false, expr = true })

-- Notifications
map("n", "<leader>nd", function()
  Snacks.notifier.hide()
end, { desc = "[d]ismiss messages" })
map("n", "<leader>sm", function()
  Snacks.notifier.show_history()
end, { desc = "[m]essages" })

map("n", "<leader>tt", "<cmd>Twilight<CR>", { desc = "[t]wilight (focus scope hl)" })
map("n", "<Leader>t_", ChgListchars, { desc = "Toggle Whitespace (_) rendering" })

-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
  "n",
  "<Leader>dd",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- rustaceanvim
-- map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })
--

-- InspectTree
map("n", "<Leader>tT", "<cmd>InspectTree<CR>", { desc = "[T]reesitter AST Inspect" })

---@param mods string filename-modifiers
---@return string
-- :h filename-modifiers
local function get_path(mods)
  return vim.fn.fnamemodify(vim.fn.expand("%"), mods)
end

---@param path string
local function copy_to_clipboard(path)
  vim.fn.setreg("+", path)
  vim.api.nvim_echo({ { "Copied: " .. path } }, false, {})
end

map("n", "<Leader>fc", function()
  copy_to_clipboard(get_path(":."))
end, { desc = "[c]opy path (relative)" })

map("n", "<Leader>fx", function()
  vim.ui.open(vim.fn.expand("%"))
end, { desc = "open current file" })

map("n", "<Leader>fr", function()
  vim.cmd('edit!')
end, { desc = "reload current file" })

---@param mode string the mode
---@param key_string string a string of inputs (accepts termcodes eg. <CR>)
local function feedkeys(mode, key_string)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key_string, true, false, true), mode, true)
end

-- [r]efactor: [s]quash self
-- (eg. turn "string.match(target, pattern)" -> "target:match(pattern)")
-- implemented for: lua
-- map("n", "<Leader>rs", function()
--   if vim.bo.filetype == "lua" then
--     feedkeys("n", "F.hdiwr:m`/(<CR>ldw``P/(<CR>ldw")
--   end
-- end, { desc = "[s]quash" })

map('c', '<C-h>', '<Left>', { noremap = true })
map('c', '<C-l>', '<Right>', { noremap = true })
map('c', '<C-j>', '<Down>', { noremap = true })
map('c', '<C-k>', '<Up>', { noremap = true })
map('c', '<C-b>', '<S-Left>', { noremap = true })
map('c', '<C-f>', '<S-Right>', { noremap = true })

map('v', '/', "\"fy/\\V<C-R>f<CR>", { desc = "search selection" })

vim.keymap.set('n', '<leader>p', function()
  vim.o.paste = true
  vim.cmd('normal! "+p')
  vim.o.paste = false
end, { desc = 'Paste without formatting (after cursor)' })


map('n', '<leader>Bd', vim.api.nvim_buf_delete, { desc = "[d]elete current buffer"} )
map('n', '<leader>BD', function()
  vim.api.nvim_buf_delete(0, { force = true })
end, { desc = "force [D]elete current buffer"} )
