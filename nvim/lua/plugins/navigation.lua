return {
  {
    -- even better % and matching words
    "andymass/vim-matchup",
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      ---@type table<string, Flash.Config>
      modes = {
        search = { enabled = false },
        char = { enabled = false },
      },
      highlight = {
        groups = {
          current = "FlashMatch", -- less confusing with color scheme
        },
      },
    },
    init = function()
      local flash = require("flash")
      vim.keymap.set({ "n", "x", "o" }, "s", function()
        flash.jump({})
      end, { desc = "Flash" })
      vim.keymap.set({ "n", "x", "o" }, "S", function()
        flash.jump({})
      end, { desc = "Flash" })
      vim.keymap.set("o", "r", function()
        flash.remote({})
      end, { desc = "Flash (remote)" })
    end,
  },
  {
    "cbochs/grapple.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    opts = {
      scope = "git_branch",
      win_opts = {
        width = 0.9,
        height = 20
      }
    },
    keys = {
      { "<leader>fa", "<cmd>Grapple toggle<cr>",          desc = "Tag a file" },
      { "<c-e>",      "<cmd>Grapple toggle_tags<cr>",     desc = "Toggle tags menu" },

      { "<c-h>",      "<cmd>Grapple select index=1<cr>",  desc = "grapple 1" },
      { "<c-t>",      "<cmd>Grapple select index=2<cr>",  desc = "grapple 2" },
      { "<c-n>",      "<cmd>Grapple select index=3<cr>",  desc = "grapple 3" },
      { "<c-s>",      "<cmd>Grapple select index=4<cr>",  desc = "grapple 4" },
      { "<c-_>",      "<cmd>Grapple select index=5<cr>",  desc = "grapple 5" },

      { "<c-s-n>",    "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
      { "<c-s-p>",    "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
    },
  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      "folke/snacks.nvim",
    },
    keys = {
      {
        "<leader>bc",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>b<leader>",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>br",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      open_for_directories = true,
      floating_window_scaling_factor = 1,
      set_keymappings_function = function(bufnr, config, context)
        vim.api.nvim_create_autocmd("TermLeave", {
          callback = function()
            context.api:emit_to_yazi({ "quit" })
          end,
          buffer = bufnr,
          desc = "Yazi: quit if leaving terminal mode",
        })
      end,
    },
    init = function()
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
    config = function(_, opts)
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require("ibl.hooks")

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#72373c" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#75623f" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#31597a" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#6b4f34" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#4e633e" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#653d71" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#2c5d63" })
      end)

      hooks.register(hooks.type.ACTIVE, function(bufnr)
        local allowed = {
          gdscript = true,
          python = true,
        }
        curr = vim.opt_local.filetype:get()
        return allowed[curr]
      end)

      require("ibl").setup({
        indent = {
          highlight = highlight,
        },
        scope = { enabled = false },
      })
    end,
  },
}
