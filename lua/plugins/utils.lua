return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Go To Previous Tmux Pane" },
    },
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
    event = "VeryLazy",
    keys = {
      {
        "]g",
        "<cmd>lua require('gitsigns').next_hunk()<cr>",
        desc = "Next Git Hunk",
        mode = "n",
      },
      {
        "[g",
        "<cmd>lua require('gitsigns').prev_hunk()<cr>",
        desc = "Previous Git Hunk",
        mode = "n",
      },
    },
  },
  {
    "folke/which-key.nvim",
    dependencies = { "echasnovski/mini.nvim" },
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    opts = {
      defaults = {
        ["<leader>x"] = { name = "+REPL" },
        ["<leader>xm"] = { name = "+Mark" },
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      -- Enable sub-plugins
      require("mini.surround").setup()
      require("mini.comment").setup()
      require("mini.ai").setup()
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      open_fold_hl_timeout = 150,
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
      },
      provider_selector = function(_, _, _)
        return { "treesitter", "indent" }
      end,
    },
  },
  {
    "numToStr/FTerm.nvim",
    opts = {
      dimensions = {
        height = 0.9,
        width = 0.9,
      },
      blend = 10,
    },
    keys = {
      {
        "<leader>T",
        "<cmd>lua require('FTerm').toggle()<cr>",
        desc = "Toggle FTerm",
        mode = "n",
      },
      {
        "<C-T>",
        '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>',
        desc = "Toggle FTerm",
        mode = "t",
      },
    },
  },
}
