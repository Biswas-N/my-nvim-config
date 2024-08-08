return {
  {
    "nvimdev/dashboard-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    opts = {
      theme = "hyper",
      config = {
        week_header = {
          enable = true,
        },
        shortcut = {
          { desc = "Update", action = "Lazy update", key = "u" },
          {
            desc = "Files",
            action = "Telescope find_files",
            key = "f",
          },
          {
            desc = "Commits",
            action = "Telescope git_commits",
            key = "g",
          },
          {
            desc = "Quit",
            action = "qa",
            key = "q",
          },
        },
      },
    },
  },
  {
    "catppuccin/nvim",
    priority = 1000,
    lazy = false,
    name = "catppuccin",
    opts = {
      integrations = {
        nvimtree = true,
        treesitter = true,
        cmp = true,
        gitsigns = true,
        notify = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      options = {
        theme = "catppuccin",
      },
      sections = {
        lualine_c = {
          { "filename", path = 1 }, -- This will show the relative path
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "4.7.0",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {},
  },
  {
    "rcarriga/nvim-notify",
    opts = {},
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_default",
      },
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = true
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
  },
}
