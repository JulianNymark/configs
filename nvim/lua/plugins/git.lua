return {
  "lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next", { greedy = false })
        end
      end, { desc = "next hunk" })

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev", { greedy = false })
        end
      end, { desc = "prev hunk" })

      map("n", "<C-j>", function()
        gitsigns.nav_hunk("next", { greedy = false })
      end, { desc = "next hunk" })

      map("n", "<C-k>", function()
        gitsigns.nav_hunk("prev", { greedy = false })
      end, { desc = "prev hunk" })

      -- Actions
      map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "[r]eset hunk" })
      map("v", "<leader>gr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "[r]eset hunk (visual)" })
      map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "[R]eset buffer" })
      map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "[p]review hunk" })
      map("n", "<leader>gb", function()
        gitsigns.blame_line({ full = true })
      end, { desc = "[b]lame line" })
      map("n", "<leader>gB", function()
        gitsigns.blame()
      end, { desc = "[B]lame buffer" })
      map("n", "<leader>gq", gitsigns.setqflist, { desc = "[q]uickfix list" })
      map("n", "<leader>gQ", function()
        gitsigns.setqflist("all")
      end, { desc = "[Q]uickfix all" })
      map("n", "<leader>gd", gitsigns.diffthis, { desc = "[d]iff file" })
      map("n", "<leader>gD", function()
        gitsigns.diffthis("~")
      end, { desc = "[D]iff HEAD" })

      -- Toggles
      map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "git [b]lame" })
      map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "git [w]ord diff" })
    end,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 10,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
  },
  -- {
  --   "NeogitOrg/neogit",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",  -- required
  --     "sindrets/diffview.nvim", -- optional - Diff integration
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- }
}
