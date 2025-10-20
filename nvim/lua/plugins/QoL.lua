return {
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      require("mini.ai").setup({ n_lines = 500 })

      -- NOTE: mini.surround seems not as powerful as nvim.surround
      -- still want a way to use tree-sitter for the {,(,[ matchers... (currently it matches on _any_, eg string contents...)
      -- I want to be able to distinguish between both, but usually I think I want code cognizant matches (so tree-sitter)
      -- require("mini.surround").setup() -- USING nvim.surround instead! (has more features)

      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end

      require("mini.move").setup({
        mappings = {
          left = "H",
          right = "L",
          down = "J",
          up = "K",
          -- wack behaviour when tapping esc before hjkl?! (maybe a karabiner thing)
          -- seems to trigger <M-*> somehow? therefore disabling those here
          line_left = "",
          line_right = "",
          line_down = "",
          line_up = "",
        },
      })

      require("mini.operators").setup({
        evaluate = {
          prefix = "-=",
        },
        exchange = {
          prefix = "-x",
        },
        multiply = {
          prefix = "-m",
        },
        replace = {
          prefix = "-r",
        },
        sort = {
          prefix = "-s",
        },
      })

      -- more at https://github.com/echasnovski/mini.nvim
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      local surr = require("nvim-surround")
      local surr_utils = require("nvim-surround.config")
      surr.setup({
        -- Configuration here, or leave empty to use defaults
        aliases = {
          -- brackets, curly brackets, square brackets
          ["b"] = { ")", "}", "]" },
        },
        surrounds = {
          -- CSS block
          ["c"] = {
            add = function()
              local input = surr_utils.get_input("Enter a CSS selector: ")
              if input then
                return {
                  { input .. " {" },
                  {
                    "}",
                  },
                }
              end
              return { { "" }, { "" } }
            end,
          },
          -- template literal (string)
          ["s"] = {
            add = function()
              return { { "`${" }, { "}`" } }
            end,
          },
          -- BBCode block
          ["b"] = {
            add = function()
              local input = surr_utils.get_input("Enter a BBCode tag: ")
              if input and input ~= "" then
                return {
                  { "[" .. input .. "]" },
                  { "[/" .. input .. "]"
                  },
                }
              end
              return { { "[code]" }, { "[/code]" } }
            end,
          },
          -- fancy comment header
          ["h"] = {
            add = function()
              local commentstring = vim.bo.commentstring or "// %s"
              local prefix = commentstring:match("^(.-)%s") or "//"
              local comment_char = prefix:sub(1, 1)

              local is_single_char = prefix:match("^(%S)%1+$") ~= nil
              if not is_single_char and #prefix > 1 then
                comment_char = prefix:sub(2, 2)
              end

              -- Get visual selection
              local start_line = vim.fn.getpos("'<")[2] - 1
              local end_line = vim.fn.getpos("'>")[2]

              local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
              if not lines or #lines == 0 then
                return
              end

              -- Strip leading/trailing whitespace and add comment prefix
              for i, line in ipairs(lines) do
                local trimmed = line:gsub("^%s*(.-)%s*$", "%1")
                if not trimmed:find("^" .. vim.pesc(prefix)) then
                  lines[i] = prefix .. " " .. trimmed
                end
              end

              vim.api.nvim_buf_set_lines(0, start_line, end_line, false, lines)

              -- Get the max line length (including comment char)
              local max_len = 0
              for _, line in ipairs(lines) do
                max_len = math.max(max_len, #line)
              end

              -- Create the top and bottom border line
              local border = comment_char:rep(max_len)

              if is_single_char then
                border = prefix .. comment_char:rep(max_len - #prefix)
              end

              return { { border }, { border } }
            end,
          },
        },
      })
    end,
  },
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      float_diff = true,
      diff_previewer = {
        diff_highlight = true,
      },
      window = {
        winblend = 0,
      },
    },
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "[u]ndotree" },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      require("nvim-autopairs").setup()
    end,
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
  },
  {
    "Wansmer/sibling-swap.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      keymaps = {
        ["<space>."] = "swap_with_right_with_opp",
        ["<space>,"] = "swap_with_left_with_opp",
      },
    },
    config = function(_, opts)
      local swap = require("sibling-swap")
      swap.setup(opts)
      vim.keymap.set("n", "<leader>.", swap.swap_with_right_with_opp, { desc = "swap with right sibling" })
      vim.keymap.set("n", "<leader>,", swap.swap_with_left_with_opp, { desc = "swap with left sibling" })
    end,
  },
  -- The following configuration
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      local wk = require("which-key")
      wk.setup()

      -- Document existing key chains
      wk.add({
        { "<leader><leader>", group = "FileType specific" },
        { "<leader>a",        group = "[a]i" },
        { "<leader>b",        group = "[b]rowse" },
        { "<leader>c",        group = "[c]ode" },
        { "<leader>d",        group = "[d]ebug" },
        { "<leader>f",        group = "[f]ile" },
        { "<leader>g",        group = "[g]it" },
        { "<leader>n",        group = "[n]oice" },
        { "<leader>r",        group = "[r]efactor" },
        { "<leader>R",        group = "[R]equests" },
        { "<leader>s",        group = "[s]earch" },
        { "<leader>t",        group = "[t]oggle" },
        { "<leader>w",        group = "[w]orkspace" },
        { "gr",               group = "LSP" },
      })

      -- visual mode
      wk.add({
        { "<leader>h", desc = "Git [h]unk" },
      }, { mode = "v" })
    end,
  },
  {
    -- BUG: a quick `gc` + slow `c` doesn't work, but slow `g`+`c`+`c` does, quick `gcc` does
    "numToStr/Comment.nvim",
    opts = {},
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      local comment = require("Comment")
      ---@diagnostic disable-next-line: missing-fields
      comment.setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
  -- "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  {
    -- folding
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufRead",
    opts = {},
    config = function()
      vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.opt.foldcolumn = "1" -- '0' is not bad
      vim.opt.foldlevel = 99   -- Using nvim-ufo provider requires a large value
      vim.opt.foldenable = true
      vim.opt.foldlevelstart = 99

      require("ufo").setup()
    end,
  },
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      local grug = require("grug-far")
      grug.setup({});

      vim.keymap.set({ "n", "x" }, '<leader>rf', function()
        grug.open()
      end, { desc = "[r]eplace" })

      vim.keymap.set({ "n", "x" }, '<leader>rF', function()
        grug.open({ visualSelectionUsage = 'operate-within-range' })
      end, { desc = "[r]eplace within visual" })
    end
  },
}
