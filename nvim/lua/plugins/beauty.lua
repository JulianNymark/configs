return {
  {
    "nyoom-engineering/oxocarbon.nvim",
    config = function()
      -- vim.cmd.colorscheme("oxocarbon")
    end,
  },
  {
    "ayu-theme/ayu-vim",
    config = function()
      -- vim.cmd.colorscheme("ayu")
    end,
  },
  {
    {
      "maxmx03/fluoromachine.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        local fm = require("fluoromachine")

        local redBg = "#350000"
        local greenBg = "#002500"
        local yellowBg = "#352500"
        local redBgStrong = "#440000"
        local greenBgStrong = "#004400"
        local yellowBgStrong = "#444400"

        local redFg = "#ffffff"
        local greenFg = "#ffffff"
        local yellowFg = "#ffffff"
        local redFgStrong = "#ff0000"
        local greenFgStrong = "#00ff00"
        local yellowFgStrong = "#ffaa00"

        local neogitCursorFg = "#ffffff"
        local neogitCursorBg = "#444444"
        local neogitCursorRedFg = "#ff0000"
        local neogitCursorRedBg = "#663333"
        local neogitCursorGreenFg = "#00ff00"
        local neogitCursorGreenBg = "#336633"

        local function overrides(c, color)
          return {
            ["@text.diff.add"] = { link = "DiffAdd" },
            ["@text.diff.delete"] = { link = "DiffDelete" },
            ["diffLine"] = { fg = "#888888" },
            ["diffAdded"] = { fg = greenFgStrong },
            ["diffRemoved"] = { fg = redFgStrong },
            ["CursorLine"] = { bg = "#35008d" },
            ["Visual"] = { bg = "#4600b8" },
            ["DiffAdd"] = { fg = greenFg, bg = greenBg },
            ["DiffDelete"] = { fg = redFg, bg = redBg },
            ["DiffChange"] = { fg = yellowFg, bg = yellowBg },

            ["GitSignsAdd"] = { fg = greenFgStrong },
            ["GitSignsDelete"] = { fg = redFgStrong },
            ["GitSignsChange"] = { fg = yellowFgStrong },
            ["GitSignsAddInline"] = { fg = greenFgStrong, bg = greenBgStrong },
            ["GitSignsDeleteInline"] = { fg = redFgStrong, bg = redBgStrong },
            ["GitSignsChangeInline"] = { fg = yellowFgStrong, bg = yellowBgStrong },

            ["NeogitDiffAdd"] = { fg = greenFg, bg = greenBg },
            ["NeogitDiffDelete"] = { fg = redFg, bg = redBg },
            ["NeogitDiffContext"] = { fg = yellowFg, bg = "NONE" },
            ["NeogitDiffAddHighlight"] = { fg = greenFgStrong, bg = greenBgStrong },
            ["NeogitDiffDeleteHighlight"] = { fg = redFgStrong, bg = redBgStrong },
            ["NeogitDiffContextHighlight"] = { fg = "#ffffff", bg = "NONE" },
            ["NeogitHunkHeader"] = { fg = "#888888", bg = "#1a1a1a" },
            ["NeogitHunkHeaderHighlight"] = { fg = "#ffffff", bg = "NONE" },
            ["NeogitDiffContextCursor"] = { fg = neogitCursorFg, bg = neogitCursorBg },
            ["NeogitDiffAddCursor"] = { fg = neogitCursorGreenFg, bg = neogitCursorGreenBg },
            ["NeogitDiffDeleteCursor"] = { fg = neogitCursorRedFg, bg = neogitCursorRedBg },
          }
        end

        fm.setup({
          glow = true,
          theme = "fluoromachine",
          transparent = true,
          overrides = overrides,
        })

        vim.cmd.colorscheme("fluoromachine")
      end,
    },
  },
  {
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- vim.cmd.colorscheme("catppuccin-mocha")

      -- You can configure highlights by doing something like:
      -- vim.cmd.hi("Comment gui=none")
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        input = {
          relative = "cursor",
          row = -3,
          col = -2,
        },
      },
      input = {
        enabled = true,
      },
    },
    config = function(_, opts) -- for @type
      local snacks = require("snacks")
      snacks.setup(opts)
    end,
  },
  {
    -- it's a bit buggy when the preview triggers before i select the command
    -- if type `:Inc` in the command input (but it's not meant to be used that way)
    -- but it shouldn't "do that"
    -- "smjonas/inc-rename.nvim",
    "JulianNymark/inc-rename.nvim",
    branch = "snacks-set-title",
    opts = {
      input_buffer_type = "snacks",
    },
    config = function(_, opts)
      local incr = require("inc_rename")
      incr.setup(opts)
    end,
  },
  {
    "tummetott/reticle.nvim",
    event = "VeryLazy", -- optionally lazy load the plugin
    opts = {
      -- add options here if you wish to override the default settings
    },
  },
}
