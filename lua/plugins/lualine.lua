return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    sections = {
      lualine_c = {
        { "filename", path = 1 }, -- This will show the relative path
      },
      lualine_x = { "encoding", { "fileformat", symbols = { unix = "" } }, "filetype" },
    },
  },
}
