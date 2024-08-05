return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- Debug based keymaps
      vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Debug Breakpoint Toggle", remap = true })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug Continue", remap = true })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      -- Attaching DAP UI to DAP events
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
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local dapui, py_dap = require("dapui"), require("dap-python")

      dapui.setup()
      py_dap.setup("python")

      -- Python Debug based keymaps
      vim.keymap.set("n", "<leader>dpm", py_dap.test_method, { desc = "Debug Python Test Method", remap = true })
      vim.keymap.set("n", "<leader>dpc", py_dap.test_class, { desc = "Debug Python Test Class", remap = true })
    end,
  },
}
