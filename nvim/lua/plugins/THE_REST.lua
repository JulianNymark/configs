return {
  {
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
  },
}
