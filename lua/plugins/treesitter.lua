return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    opts = {
      ensure_installed = { "python", "rust" },
      auto_install = true,
      highlight = {
        additional_vim_regex_highlighting = false,
        enable = true,
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {},
    build = ":TSContextEnable",
    event = "BufRead",
    key = {
      {
        "[c",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        mode = "n",
        desc = "Go to previous context",
      },
    },
  },
}
