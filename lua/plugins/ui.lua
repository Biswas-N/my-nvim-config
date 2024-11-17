local function buffer_count()
  return #vim.fn.getbufinfo({ buflisted = 1 })
end

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
        diffview = true,
        nvimtree = true,
        treesitter = true,
        cmp = true,
        gitsigns = true,
        harpoon = true,
        mason = true,
        neotree = true,
        noice = true,
        notify = true,
        nvim_surround = true,
        dadbod_ui = true,
        which_key = true,
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
        icons_enabled = true,
        theme = "catppuccin",
        disabled_filetypes = {},
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          {
            "branch",
            fmt = function(name, _)
              -- truncate branch name in case the name is too long
              return string.sub(name, 1, 20)
            end,
          },
        },
        lualine_c = {
          {
            "filename",
            symbols = {
              readonly = "[🔒]",
            },
            path = 1,
          },
          {
            "diff",
            source = function()
              local git_status = vim.b.gitsigns_status_dict
              if git_status == nil then
                return
              end

              local modify_num = git_status.changed
              local remove_num = git_status.removed
              local add_num = git_status.added

              local info = { added = add_num, modified = modify_num, removed = remove_num }
              -- vim.print(info)
              return info
            end,
          },
        },
        lualine_x = {
          "diagnostics",
          "location",
        },
        lualine_y = {
          "encoding",
          "filetype",
        },
        lualine_z = {},
      },
      inactive_sections = {
        lualine_c = { "filename" },
        lualine_x = { "location" },
      },
      extensions = { "nvim-tree", "oil", "lazy", "mason", "nvim-dap-ui", "symbols-outline", "trouble" },
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            separator = true,
            text_align = "left",
          },
        },
        diagnostics = "nvim_lsp",
        separator_style = { "", "" },
        modified_icon = "●",
        show_close_icon = false,
        show_buffer_close_icons = true,
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
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        position = "left",
        width = 40,
        mappings = {
          Y = "copy_selector",
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_default",
      },
      commands = {
        copy_selector = function(state)
          -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
          -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local results = {
            filepath,
            modify(filepath, ":."),
            modify(filepath, ":~"),
            filename,
            modify(filename, ":r"),
            modify(filename, ":e"),
          }

          vim.ui.select({
            "1. Absolute path: " .. results[1],
            "2. Path relative to CWD: " .. results[2],
            "3. Path relative to HOME: " .. results[3],
            "4. Filename: " .. results[4],
            "5. Filename without extension: " .. results[5],
            "6. Extension of the filename: " .. results[6],
          }, { prompt = "Choose to copy to clipboard:" }, function(choice)
            if choice then
              local i = tonumber(choice:sub(1, 1))
              if i then
                local result = results[i]
                vim.fn.setreg("+", result)
                vim.notify("Copied: " .. result)
              else
                vim.notify("Invalid selection")
              end
            else
              vim.notify("Selection cancelled")
            end
          end)
        end,
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
        buftypes = { "terminal" },
      },
    },
  },
  {
    "fei6409/log-highlight.nvim",
    config = function()
      require("log-highlight").setup({})
    end,
  },
}
