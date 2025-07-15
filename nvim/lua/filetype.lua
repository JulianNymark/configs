vim.filetype.add({
  extension = {
    dialogue = "dialogue"
  }
})

-- this is for non-LSP setup,
-- this gets overriden if the LSP controls any behaviour
-- also, .editorconfig will override this as well

-- handy for debugging
-- :verbose set expandtab?

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gdscript", "python" },
  callback = function()
    vim.bo.expandtab = true -- Use spaces instead of tabs
    vim.bo.tabstop = 4      -- Number of spaces a <Tab> counts for
    vim.bo.shiftwidth = 4   -- Number of spaces for each indent
    vim.bo.softtabstop = 4  -- Number of spaces for <Tab> in insert mode
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dialogue" },
  callback = function()
    vim.print("dialogue file")
    vim.bo.expandtab = false
    vim.bo.tabstop = 4     -- Number of spaces a <Tab> counts for
    vim.bo.shiftwidth = 4  -- Number of spaces for each indent
    vim.bo.softtabstop = 4 -- Number of spaces for <Tab> in insert mode
  end,
})
