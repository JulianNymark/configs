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

return M
