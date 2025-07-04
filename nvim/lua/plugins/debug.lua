return {
  -- {
  -- 	"mrcjkb/rustaceanvim",
  -- 	version = "^5", -- Recommended
  -- 	lazy = false, -- This plugin is already lazy
  -- 	ft = "rust",
  -- 	config = function()
  -- 		local mason_registry = require("mason-registry")
  -- 		local codelldb = mason_registry.get_package("codelldb")
  -- 		local extension_path = codelldb:get_install_path() .. "/extension/"
  -- 		local codelldb_path = extension_path .. "adapter/codelldb"
  -- 		local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
  -- 		-- If you are on Linux, replace the line above with the line below:
  -- 		-- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  -- 		local cfg = require("rustaceanvim.config")
  --
  -- 		vim.g.rustaceanvim = {
  -- 			dap = {
  -- 				adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
  -- 			},
  -- 		}
  -- 	end,
  -- },
  --
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "/usr/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Rust debug",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = true,
        },
      }

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },
}
