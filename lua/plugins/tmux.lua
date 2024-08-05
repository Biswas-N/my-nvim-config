return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Go To Previous Tmux Pane" },
  },
}
