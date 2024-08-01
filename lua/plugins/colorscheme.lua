return {
  -- add catppuccin
  { "catppuccin/nvim", name = "catppuccin", lazy = true },

  -- config LazyVim to load catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
