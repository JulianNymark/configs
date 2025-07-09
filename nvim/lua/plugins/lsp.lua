return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { "mason-org/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- Useful status updates for LSP.
    { "j-hui/fidget.nvim",    opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { "folke/lazydev.nvim",   opts = {} },
  },
  config = function()
    local custom_lsp_disables = function(event)
      local is_deno_project = function()
        local buf_dir = vim.fn.expand("%:p:h")
        local found_dir =
            require("lspconfig").util.root_pattern("deno.json", "deno.jsonc", "deno.lock")(buf_dir)
        if found_dir then
          return true
        end
        return false
      end

      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client and client.name == "ts_ls" and is_deno_project() then
        vim.print("LspAttach: disabling ts_ls for buffer due to auto detecting deno project")
        -- NOTE: stopping the client, since the buffer seems to still want to talk to the
        -- lsp despite it being detached (gives errors)
        vim.lsp.stop_client(event.data.client_id)
        -- vim.lsp.buf_detach_client(event.buf, event.data.client_id)
      elseif client and client.name == "denols" and not is_deno_project() then
        vim.print("LspAttach: disabling denols for buffer due to NOT auto detecting deno project")
        -- NOTE: stopping the client, since the buffer seems to still want to talk to the
        -- lsp despite it being detached (gives errors)
        vim.lsp.stop_client(event.data.client_id)
        -- vim.lsp.buf_detach_client(event.buf, event.data.client_id)
      end
    end

    local filetype_logic = function(event)
      local bufnr = event.buf
      local ft = vim.bo[bufnr].filetype
      if ft == "python" or ft == "gdscript" then
        vim.bo[bufnr].expandtab = true
        vim.bo[bufnr].tabstop = 4
        vim.bo[bufnr].shiftwidth = 4
        vim.bo[bufnr].softtabstop = 4
      end
    end

    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*.gd",
      callback = function(event)
        --------------------------------------------------------------------------------------------------------
        -- Use External Editor: On
        -- Exec Path: nvim
        -- Exec Flags: --server /tmp/godot.pipe --remote-send "<esc>:n {file}<CR>:call cursor({line},{col})<CR>"
        --------------------------------------------------------------------------------------------------------

        local pipe = "/tmp/godot.pipe"
        local root_dir = vim.fs.dirname(vim.fs.find({ "project.godot", ".git" }, { upward = true })[1])
        local existing_client = nil

        for _, client in pairs(vim.lsp.get_clients()) do
          if client.name == "Godot" and client.config.root_dir == root_dir then
            existing_client = client
            break
          end
        end

        if existing_client then
          vim.defer_fn(function()
            vim.lsp.buf_attach_client(0, existing_client.id)
          end, 100)
        else
          local cmd = vim.lsp.rpc.connect("127.0.0.1", 6005)
          vim.lsp.start({
            name = "Godot",
            cmd = cmd,
            root_dir = root_dir,
            on_attach = function(client, bufnr)
              vim.fn.serverstart(pipe)
            end,
          })
        end
      end,
    })

    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        -- WARN: automatically disable certain LSPs under certain conditions!!
        -- this could lead to strange behaviour! (beware of doing too much "magic", add printouts!)
        custom_lsp_disables(event)

        filetype_logic(event)

        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", require("telescope.builtin").lsp_definitions, "[g]oto [d]efinition")
        -- NOTE: default for gd is a "lesser" version of lsp variant (local only)

        map("grr", require("telescope.builtin").lsp_references, "[g]oto [r]eferences")
        -- NOTE: grr is a nvim default now (as of 0.11), but it's not telescope nice

        -- map("gI", require("telescope.builtin").lsp_implementations, "[g]oto [I]mplementation")
        -- NOTE: gri is a nvim default now (as of 0.11)

        -- map("<leader>rn", vim.lsp.buf.rename, "re[n]ame")
        -- NOTE: grn is a nvim default now (as of 0.11)

        -- map("<leader>ca", vim.lsp.buf.code_action, "[a]ction")
        -- NOTE: gra is a nvim default now (as of 0.11)

        --  Symbols are things like variables, functions, types, etc.
        map("gO", require("telescope.builtin").lsp_document_symbols, "file symb[o]ls")
        -- NOTE: gO default does not integrate nicely with telescope

        map("grt", require("telescope.builtin").lsp_type_definitions, "[t]ype definition")

        map("grD", vim.lsp.buf.declaration, "[D]eclaration")

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map("grW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[w]orkspace [s]ymbols")

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        map("K", function()
          vim.lsp.buf.hover({
            border = "rounded",
            max_width = 75,
          })
        end, "Hover Documentation")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "[t]oggle Inlay [h]ints")
        end
      end,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
      callback = function(event)
        vim.lsp.buf.clear_references()

        autocmd_group_exists = vim.tbl_filter(function(elem)
          return elem.group_name == "kickstart-lsp-highlight"
        end, vim.api.nvim_get_autocmds({}))

        if not vim.tbl_isempty(autocmd_group_exists) then
          vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event.buf })
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    local organize_imports = function()
      local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "",
      }
      vim.lsp.buf.execute_command(params)
    end

    local lspconfig = require("lspconfig")

    -- for omnisharp
    local pid = vim.fn.getpid()
    local omnisharp_bin = "/usr/local/bin/omnisharp-roslyn/OmniSharp"

    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      clangd = {},
      pyright = {},
      rust_analyzer = {
        -- until https://github.com/hrsh7th/cmp-nvim-lsp/issues/72 is solved
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      },
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim

      denols = {
        root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),
      },
      ts_ls = {},
      tailwindcss = {},
      eslint = {},
      -- eslint_d = {},
      prettierd = {},
      cssls = {
        settings = {
          css = {
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      },
      lua_ls = {
        -- server_capabilities = {
        -- 	semanticTokensProvider = vim.NIL,
        -- },
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            completion = {
              callSnippet = "Replace",
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      cssmodules_ls = {
        -- init_options = {
        -- 	camelCase = "dashes",
        -- },
        on_attach = function(client)
          -- sadly this LSP collides with ts_ls
          client.server_capabilities.definitionProvider = false
        end,
      },

      -- prettier = {},
      -- biome = {
      -- 	 root_dir = function(fname)
      -- 		local util = require("lspconfig.util")
      -- 	 	return util.root_pattern("biome.json", "biome.jsonc")(fname)
      -- 	 		or util.find_package_json_ancestor(fname)
      -- 	 		or util.find_node_modules_ancestor(fname)
      -- 	 		or util.find_git_ancestor(fname)
      -- 	 end,
      -- },
      jsonls = {},
      omnisharp = {
        cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
      },
      html = {},
      gdtoolkit = {},
      ["bash-language-server"] = {},
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu.
    require("mason").setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua", -- Used to format Lua code
    })
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      automatic_enable = true,
      ensure_installed = {},
      automatic_installation = true,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
