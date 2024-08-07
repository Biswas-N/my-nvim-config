return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  opts = {
    ensure_installed = { "python", "javascript", "csv" },
    auto_install = true,
    sync_install = true,
    highlight = { enable = true },
  },
}
