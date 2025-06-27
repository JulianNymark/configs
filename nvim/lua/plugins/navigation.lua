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
        char   = { enabled = true, jump_labels = true },
      },
      highlight = {
        groups = {
          current = "FlashMatch" -- less confusing with color scheme
        }
      }
    },
    init = function()
      local flash = require("flash")
      vim.keymap.set({ "n", "x", "o" }, "F", function()
        flash.jump({})
      end, { desc = "Flash" })
      vim.keymap.set({ "n", "x", "o" }, "f", function()
        flash.jump({
          search = {
            mode = function(str)
              return "\\<" .. str
            end,
          }
        })
      end, { desc = "Flash (words)" })
      vim.keymap.set("o", "r", function()
        flash.remote({})
      end, { desc = "Flash (remote)" })
    end
  },
  {
    "cbochs/grapple.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    opts = {
      scope = "git_branch",
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
    },
    init = function()
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
