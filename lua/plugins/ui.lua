return {
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
        disabled_filetypes = {
          winbar = { "dapui_watches", "dapui_breakpoints", "dapui_scopes", "dapui_console", "dapui_stacks", "dap-repl" },
        },
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
      tabline = {
        lualine_c = {
          {
            function()
              local current_tab = vim.fn.tabpagenr()
              local buffers_in_tab = {}

              -- Get buffers that belong to the current tab
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
                local buf = vim.api.nvim_win_get_buf(win)
                local bufname = vim.fn.bufname(buf)
                if bufname ~= "" then
                  table.insert(buffers_in_tab, vim.fn.fnamemodify(bufname, ":t"))
                end
              end

              -- Format the buffer names nicely
              if #buffers_in_tab > 0 then
                return table.concat(buffers_in_tab, " | ")
              else
                return "No Buffers"
              end
            end
          }
        },
        lualine_z = {"tabs"},
      },
      extensions = { "nvim-tree", "lazy", "mason", "nvim-dap-ui", "symbols-outline", "trouble" },
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
