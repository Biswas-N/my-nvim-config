return {
  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set(
        "i",
        "<C-j>",
        "copilot#Accept('<CR>')",
        { noremap = true, silent = true, expr = true, replace_keycodes = false }
      )
    end,
  },
}
