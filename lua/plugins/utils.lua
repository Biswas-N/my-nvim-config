return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({ keymaps = { ["<Esc>"] = "actions.close" } })
    end,
    keys = {
      { "=", "<cmd>Oil<cr>", mode = "n", desc = "Open Filesystem" },
      { "-", "<cmd>Oil --float<cr>", mode = "n", desc = "Open Floating Filesystem" },
    },
  },
  {
    "sindrets/diffview.nvim",
    opts = function()
      local actions = require("diffview.actions")
      return {
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
        keymaps = {
          diff3 = {
            { "n", "<leader>co", actions.conflict_choose("ours"), { desc = "Choose ours" } },
            { "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose theirs" } },
            { "n", "<leader>cb", actions.conflict_choose("base"), { desc = "Choose base" } },
            { "n", "<leader>ca", actions.conflict_choose("all"), { desc = "Choose all" } },
          },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>o", group = "overseer" },
      },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Overseer",
        ft = "OverseerList",
        open = function()
          require("overseer").open()
        end,
      })
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      opts = opts or {}
      opts.consumers = opts.consumers or {}
      opts.consumers.overseer = require("neotest.consumers.overseer")
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      require("overseer").enable_dap()
    end,
  },
}
