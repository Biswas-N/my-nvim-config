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
      icons = {
        mappings = false,
      },
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
    event = "VeryLazy",
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        mode = "n",
        desc = "Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        mode = "n",
        desc = "Close all folds",
      },
    },
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local foldedLines = endLnum - lnum
        local suffix = (" 󰁂  %d"):format(foldedLines)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0

        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
        suffix = (" "):rep(rAlignAppndx) .. suffix
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      require("ufo").setup({
        fold_virt_text_handler = handler,
      })
    end,
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
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Your setup opts here
      outline_window = {
        show_cursorline = true,
        hide_cursor = true,
      },
    },
  },
  {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    config = function(_, opts)
      require("harpoon"):setup(opts)
    end,
    keys = {
      {
        "<leader>A",
        function()
          require("harpoon"):list():add()
        end,
        desc = "harpoon file",
      },
      {
        "<leader>a",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "harpoon quick menu",
      },
      {
        "<leader>1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "harpoon to file 1",
      },
      {
        "<leader>2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "harpoon to file 2",
      },
      {
        "<leader>3",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "harpoon to file 3",
      },
      {
        "<leader>4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "harpoon to file 4",
      },
      {
        "<leader>5",
        function()
          require("harpoon"):list():select(5)
        end,
        desc = "harpoon to file 5",
      },
    },
  },
}
