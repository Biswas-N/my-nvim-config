return {
  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set("i", "<C-j>", "copilot#Accept()", { expr = true })
    end,
  },
}
