return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.schedule(function()
          if vim.o.background == "light" then
            vim.cmd("colorscheme catppuccin-latte")
          else
            vim.cmd("colorscheme tokyonight-moon")
          end
        end)
      end,
    },
  },
}
