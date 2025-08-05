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

        local function overrides(c, color)
          return {
            ["@text.diff.add"] = { link = "DiffAdd" },
            ["@text.diff.delete"] = { link = "DiffDelete" },
            ["diffLine"] = { fg = "#888888" },
            ["diffRemoved"] = { fg = "#ff0000" },
            ["diffAdded"] = { fg = "#00ff00" },
            ["CursorLine"] = { bg = "#120818" }
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
          col = -2
        }
      },
      input = {
        enabled = true,
      },
    },
    config = function(_, opts) -- for @type
      local snacks = require("snacks")
      snacks.setup(opts)
    end
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
    end
  },
  {
    'tummetott/reticle.nvim',
    event = 'VeryLazy', -- optionally lazy load the plugin
    opts = {
      -- add options here if you wish to override the default settings
    },
  }
}
