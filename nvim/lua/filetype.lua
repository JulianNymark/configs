-- this is for non-LSP setup,
-- this gets overriden if the LSP controls any behaviour
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gdscript", "python" },
  callback = function()
    vim.bo.expandtab = true -- Use spaces instead of tabs
    vim.bo.tabstop = 4      -- Number of spaces a <Tab> counts for
    vim.bo.shiftwidth = 4   -- Number of spaces for each indent
    vim.bo.softtabstop = 4  -- Number of spaces for <Tab> in insert mode
  end,
})
