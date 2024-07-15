return {
  {
    "ojroques/nvim-osc52",
    lazy = true,
    config = function()
      require("osc52").setup({
        tmux_passthrough = true,
      })
    end,
  },
}
