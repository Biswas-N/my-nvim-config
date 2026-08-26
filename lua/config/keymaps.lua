-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("t", "<C-\\><C-\\>", "<C-\\><C-n>", { desc = "Esc Terminal Mode" })
map("i", "jj", "<esc>", { desc = "Esc Terminal Mode" })

map("x", "<leader>yl", function()
  -- Exit visual mode so '< and '> marks get updated
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  local s = vim.fn.line("'<")
  local e = vim.fn.line("'>")
  vim.fn.setreg("+", vim.fn.expand("%") .. " L" .. s .. ":L" .. e)
end, { desc = "Yank path with line range" })

map("n", "<leader>yl", function()
  vim.fn.setreg("+", vim.fn.expand("%") .. " L" .. vim.fn.line("."))
end, { desc = "Yank path with current line" })
