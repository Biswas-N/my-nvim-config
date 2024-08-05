--[[
Language Configuration Template

This file configures language servers, formatters, and diagnostic tools for various programming languages.
To add support for a new language, follow this template:

local language_configs = {
  [language_name] = {
    lsp = {
      -- For a single LSP:
      name = "lsp_server_name",
      -- Optional: Additional LSP settings
      settings = {},
      filetypes = {},
      root_dir = function(fname) ... end,
      cmd_env = {},
      init_options = {},

      -- For multiple LSPs, use an array:
      -- {
      --   { name = "lsp1", ... },
      --   { name = "lsp2", ... },
      -- },
    },
    formatters = {"formatter1", "formatter2"}, -- Optional: List of formatters to use with null-ls
    diagnostics = {"diagnostic_tool1", "diagnostic_tool2"}, -- Optional: List of diagnostic tools to use with null-ls
  },
  -- Add more languages here
}

After adding a new language, ensure the formatters and diagnostic tools are installed manually using <leader>cm
--]]

-- Language-specific configurations
local language_configs = {
  lua = {
    lsp = {
      name = "lua_ls",
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
        },
      },
    },
    formatters = { "stylua" },
  },
  python = {
    lsp = {
      {
        name = "ruff",
        filetypes = { "python" },
        root_dir = function(fname)
          return require("lspconfig").util.find_git_ancestor(fname) or vim.loop.cwd()
        end,
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "error",
          },
        },
      },
      {
        name = "jedi_language_server",
        filetypes = { "python" },
        root_dir = function(fname)
          return require("lspconfig").util.find_git_ancestor(fname) or vim.loop.cwd()
        end,
      },
    },
    formatters = { "black" },
    -- diagnostics = { "flake8" },
  },
  rust = {
    lsp = { name = "rust_analyzer" },
  },
  -- Add more languages here following the template
}

-- Extract LSP server names for Mason to install
local needed_lsp = {}
for _, lang_config in pairs(language_configs) do
  if type(lang_config.lsp) == "table" then
    if lang_config.lsp.name then
      table.insert(needed_lsp, lang_config.lsp.name)
    else
      for _, lsp_config in ipairs(lang_config.lsp) do
        table.insert(needed_lsp, lsp_config.name)
      end
    end
  end
end

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = needed_lsp,
    },
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "nvimtools/none-ls.nvim",
    },
    keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
      { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>cf", vim.lsp.buf.format, desc = "Format File" },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local null_ls = require("null-ls")

      -- Set up null-ls
      local null_ls_sources = {}
      for _, lang_config in pairs(language_configs) do
        if lang_config.formatters then
          for _, formatter in ipairs(lang_config.formatters) do
            table.insert(null_ls_sources, null_ls.builtins.formatting[formatter])
          end
        end
        if lang_config.diagnostics then
          for _, diagnostic in ipairs(lang_config.diagnostics) do
            table.insert(null_ls_sources, null_ls.builtins.diagnostics[diagnostic])
          end
        end
      end

      null_ls.setup({
        sources = null_ls_sources,
      })

      -- Common on_attach function
      local on_attach = function(client, bufnr)
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Format On Save for supported LSPs
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end

      -- Set up lspconfig completions
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Set up LSP servers
      for _, lang_config in pairs(language_configs) do
        if type(lang_config.lsp) == "table" then
          if lang_config.lsp.name then
            lspconfig[lang_config.lsp.name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = lang_config.lsp.settings,
              filetypes = lang_config.lsp.filetypes,
              root_dir = lang_config.lsp.root_dir,
              cmd_env = lang_config.lsp.cmd_env,
              init_options = lang_config.lsp.init_options,
            })
          else
            for _, lsp_config in ipairs(lang_config.lsp) do
              lspconfig[lsp_config.name].setup({
                on_attach = on_attach,
                settings = lsp_config.settings,
                capabilities = capabilities,
                filetypes = lsp_config.filetypes,
                root_dir = lsp_config.root_dir,
                cmd_env = lsp_config.cmd_env,
                init_options = lsp_config.init_options,
              })
            end
          end
        end
      end
    end,
  },
}
