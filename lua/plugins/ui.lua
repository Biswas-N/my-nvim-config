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
          { desc = "Lazy", action = "Lazy", key = "l" },
          { desc = "Lazygit", action = "LazyGit", key = "g" },
          {
            desc = "Files",
            action = "Telescope find_files",
            key = "f",
          },
          {
            desc = "Commits",
            action = "Telescope git_commits",
            key = "c",
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
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
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
        lualine_b = {
          { "filename", path = 1 }, -- This will show the relative path
        },
        lualine_c = { "branch", "diff", "diagnostics" },
        lualine_x = { "encoding", "location" },
        lualine_y = { "filetype" },
        lualine_z = {},
      },
      inactive_sections = {
        lualine_c = { "filename" },
        lualine_x = { "location" },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss All Notifications",
      },
    },
    opts = {
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "echasnovski/mini.icons", "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    opts = {},
    keys = {
      {
        "-",
        "<cmd>Oil<CR>",
        desc = "Open Oil",
        mode = "n",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = true,
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
      -- if vim.fn.argc() == 1 then
      --   local stat = vim.loop.fs_stat(vim.fn.argv(0))
      --   if stat and stat.type == "directory" then
      --     require("neo-tree")
      --   end
      -- end
    end,
  },
  {
    "folke/zen-mode.nvim",
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
}
