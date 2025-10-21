local M = {}

function M.get_visual_selection()
  -- Save current mode and position
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then
    return nil -- Not in visual mode
  end

  -- Get the start and end positions of the visual selection
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  -- Adjust positions so start is before end
  if (start_line > end_line) or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #lines == 0 then
    return ""
  end

  -- If single line, just slice that line
  if #lines == 1 then
    return string.sub(lines[1], start_col, end_col)
  end

  -- Multi-line selection: trim first and last lines to selected columns
  lines[1] = string.sub(lines[1], start_col)
  lines[#lines] = string.sub(lines[#lines], 1, end_col)
  return table.concat(lines, "\n")
end

-- Git helper functions
local function is_git_repo()
  local _ = vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

local function verify_git_branch(branch_name)
  local _ = vim.fn.system("git rev-parse --verify " .. branch_name)
  return vim.v.shell_error == 0
end

function M.get_git_relative_path()
  if not is_git_repo() then
    return vim.fn.expand("%")  -- fallback to current file path
  end

  -- Get the absolute path of the current file
  local abs_path = vim.fn.expand("%:p")

  -- Get the git repository root
  local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")

  if vim.v.shell_error ~= 0 then
    return vim.fn.expand("%")  -- fallback if git command fails
  end

  -- Make sure git_root ends without a slash for consistent path building
  git_root = git_root:gsub("/$", "")

  -- Get the relative path from git root to the file
  local relative_path = abs_path:gsub("^" .. git_root:gsub("([^%w])", "%%%1") .. "/", "")

  return relative_path
end

function M.git_sharelink_prefix()
  if not is_git_repo() then
    return ""
  end

  local raw_url = vim.fn.system("git remote get-url origin"):gsub("\n", "")
  local processed_url = raw_url:gsub("^.-@", ""):gsub(":", "/"):gsub("%.git", "")
  local main_branch_name = verify_git_branch("master") and "master" or "main"

  return processed_url .. "/blob/" .. main_branch_name .. "/"
end

return M
