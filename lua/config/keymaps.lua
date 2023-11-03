-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.del("n", "<leader>l") -- Delete a keymap set by LazyVim defaults
vim.keymap.del("n", "<leader>L") -- Delete a keymap set by LazyVim defaults

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>l", "$h", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>h", "0", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { noremap = true, silent = true })
