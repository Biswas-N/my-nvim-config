return {
  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      -- add your options that should be passed to the setup() function here
      position = "right",
    },
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        ruff = {
          root_dir = function(fname)
            return require("lspconfig").util.find_git_ancestor(fname) or vim.loop.cwd()
          end,
        },
        jedi_language_server = {
          root_dir = function(fname)
            return require("lspconfig").util.find_git_ancestor(fname) or vim.loop.cwd()
          end,
        },
        tsserver = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
        },
      },
    },
  },
}
