return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      local layout = require("telescope.actions.layout")
      require("telescope").setup({
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              mirror = true,
              prompt_position = "top",
              width = 0.9,
              height = 0.9,
              preview_height = 0.6,
            },
          },
          sorting_strategy = "ascending",
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
          },
          mappings = {
            n = {
              ["<C-h>"] = layout.toggle_preview,
            },
            i = {
              ["<C-h>"] = layout.toggle_preview,
              -- ["..."] = "to_fuzzy_refine",
            },
          },
        },

        pickers = {
          lsp_references = { fname_width = 100 },
          lsp_definitions = { fname_width = 100 },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
      pcall(require("telescope").load_extension, "noice")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[h]elp" })
      -- vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[k]eymaps" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[f]iles" })
      -- vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[s]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "current [w]ord" })

      vim.keymap.set("v", "<leader>s", function()
        local searchstring = require("utils").get_visual_selection()
        vim.print(searchstring)
        builtin.grep_string({ search = searchstring })
      end, { noremap = true, desc = "search selection (grep)" })

      vim.keymap.set("n", "<leader>s<leader>", builtin.live_grep, { desc = "by grep" })
      vim.keymap.set("n", "<leader>sc", function()
        local cwd = vim.fn.expand("%:p:h")
        builtin.live_grep({ search_dirs = { cwd }, prompt_title = "[c]urrent dir (grep)" })
      end, { desc = "[c]urrent dir by grep" })
      vim.keymap.set("n", "<leader>si", function()
        builtin.live_grep({
          previewer = false,
          prompt_title = "by grep (disabled ignores)",
          additional_args = { "--no-ignore-vcs" },
        })
      end, { desc = "current dir (grep, no [i]gnore vcs)" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[d]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[r]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = 'Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "existing [b]uffers" })

      vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "[b]rowse" })
      vim.keymap.set("n", "<C-S-p>", builtin.git_files, { desc = "project files (git)" })

      -- NOTE: UFALT (unused for a long time)
      -- vim.keymap.set("n", "<leader>sp", function()
      --   builtin.grep_string({ search = vim.fn.input("Grep > ") })
      -- end, { desc = "gre[p] string" })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "in Open Files" })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[n]eovim files" })
    end,
  },
  {
    "JulianNymark/telescope-grouped-keymaps.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "folke/which-key.nvim",
    },
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>sk",
        function()
          require("telescope-grouped-keymaps").picker_grouped_keymaps({})
        end,
        desc = "[k]eymaps",
      },
    },
  },
}
