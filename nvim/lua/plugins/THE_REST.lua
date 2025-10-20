return {
  {
    "ThePrimeagen/vim-be-good",
  },
  {
    "tjdevries/sPoNGe-BoB.NvIm",
    config = function(_, opts)
      local spongebob = require("sponge-bob")
      vim.keymap.set("n", "<leader>t?", function()
        spongebob.toggle()
      end, { desc = "sPoNgEbOb" })
    end,
  },
  {
    "folke/twilight.nvim",
    opts = {
      context = 0,
    },
  },
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    config = function()
      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
      })
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    keys = {
      { "<leader>Rs", desc = "[s]end request" },
      { "<leader>Ra", desc = "Send [a]ll requests" },
      { "<leader>Rb", desc = "Open scratch [b]uffer" },
    },
    ft = { "http", "rest" },
    opts = {
      global_keymaps = true,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    },
  },
}
