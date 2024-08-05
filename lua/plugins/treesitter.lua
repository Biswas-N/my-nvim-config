return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    auto_install = true,
    sync_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
