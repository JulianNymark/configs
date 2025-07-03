return {
  {
    "zk-org/zk-nvim",
    -- branch = "fix/client-nil-error",

    config = function()
      require("zk").setup({
        picker = "telescope",
      })
    end,
  },
  {
    'nfrid/markdown-togglecheck',
    dependencies = { 'nfrid/treesitter-utils' },
    ft = { 'markdown' },
    keys = {
      {
        "<leader>t<leader>",
        function()
          require("markdown-togglecheck").toggle()
        end,
        desc = "toggle checkbox"
      }
    }
  },
}
