return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
  keys = {
    -- add a keymap to browse plugin files
    -- stylua: ignore
    {
      "<leader>/",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Workspace Search",
    },
    {
      "<leader>f",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find by Filename",
    },
    {
      "<leader>o",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find by Open Filename",
    },
    -- { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition" },
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", nowait = true },
    { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
    { "gy", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
  },
  -- This is your opts table
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        },
      },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
    },
  },
  -- To get ui-select loaded and working with telescope, you need to call
  -- load_extension, somewhere after setup function:
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("ui-select")
  end,
}
