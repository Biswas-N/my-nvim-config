return {
  "catppuccin/nvim",
  priority = 1000,
    lazy = false,
    name = "catppuccin",
    opts = {
        flavour = "latte",
        integrations = {
            lualine = true,
            nvimtree = true,
            treesitter = true,
        },
    },
    config = function()
        vim.cmd.colorscheme "catppuccin"
    end
}
