return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } }, -- Optional
    { "hrsh7th/nvim-cmp" },
  },
  ft = { "sql", "mysql", "plsql" },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  keys = {
    { "<leader>DB", ":DBUIToggle<CR>", mode = "n", desc = "Toggle DB UI" },
    { "<leader>DC", ":DBUIAddConnection<CR>", mode = "n", desc = "Add DB Connection" },
  },
  config = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 30
    vim.g.db_ui_win_position = "right"
    vim.g.db_ui_show_database_icon = 1

    local cmp = require("cmp")
    cmp.setup.filetype({ "sql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })

    -- Add autocmd to resize dbout buffer
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*.dbout",
      callback = function()
        vim.cmd("resize " .. math.floor(vim.api.nvim_win_get_height(0)))
      end,
    })
  end,
}
