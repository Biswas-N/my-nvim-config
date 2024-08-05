return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    sections = {
      lualine_x = { "encoding", { "fileformat", symbols = { unix = "" } }, "filetype" },
    },
  },
}
