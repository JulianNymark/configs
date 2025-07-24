vim.filetype.add({
  extension = {
    dialogue = "dialogue"
  }
})

-- this is for non-LSP setup, check lsp.lua for that
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
  pattern = "gdscript",
  callback = function(args)
    local root_match = vim.fs.find({ "project.godot" }, { upward = true })[1]
    if root_match then
      vim.opt.autoread = true
      vim.cmd("checktime")

      -- Create a buffer-local augroup
      local bufnr = args.buf
      local group_name = "godot_checktime_" .. bufnr
      local group = vim.api.nvim_create_augroup(group_name, { clear = true })

      -- Run :checktime when regaining focus or entering buffer
      vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
        group = group,
        buffer = bufnr,
        callback = function()
          vim.cmd("checktime")
        end,
      })

      -- Optional: notify if file is reloaded externally
      vim.api.nvim_create_autocmd("FileChangedShellPost", {
        group = group,
        buffer = bufnr,
        callback = function()
          vim.notify("Godot script reloaded from disk", vim.log.levels.INFO, { title = "GDScript" })
        end,
      })

      ---@param delimiters string[][]
      local surround_word = function(delimiters)
        local surround = require("nvim-surround")
        local buf = require("nvim-surround.buffer")
        local util = require("nvim-surround.config")
        local cache = require("nvim-surround.cache")

        -- the API doesn't expect this sneaky entrypoint!
        -- this "does the things" that calling without selection would (via user-call)
        cache.normal = { line_mode = false, count = vim.v.count1 }
        surround.normal_curpos = buf.get_curpos()
        surround.pending_surround = true
        vim.go.operatorfunc = "v:lua.require'nvim-surround'.normal_callback"

        surround.normal_surround({
          line_mode = false,
          delimiters = delimiters,
          ---@diagnostic disable-next-line: assign-type-mismatch
          selection = util.get_selection({ motion = "iw" }),
        })
      end

      -- per language util maps
      vim.keymap.set('n', '<Leader><Leader>s',
        function()
          surround_word({ { "str(" }, { ")" } })
        end, { desc = "str() around word", buffer = args.buf })
    end
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
