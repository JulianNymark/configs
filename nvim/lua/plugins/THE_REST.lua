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
    end
  },
  {
    "folke/twilight.nvim",
    opts = {
      context = 0,
    },
  },
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    config = function()
      -- Setup orgmode
      require('orgmode').setup({
        org_agenda_files = '~/orgfiles/**/*',
        org_default_notes_file = '~/orgfiles/refile.org',
      })
    end,
  },
  {
    "rest-nvim/rest.nvim",
    -- also some dependencies specified in packages.lua...
    -- some luarocks stuff... it's seemingly kinda jank
    -- origin of hack: https://github.com/rest-nvim/rest.nvim/issues/306
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "http")
      end,
    }
  }
}
