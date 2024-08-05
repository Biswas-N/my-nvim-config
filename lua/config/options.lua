-- Global parameters
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Buffer Parameters
vim.b.autoformat = true -- format a buffer automatically

-- Global Options
local opt = vim.opt

opt.autowrite = true -- Enable auto write

-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2                                    -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true                                      -- Confirm to save changes before exiting modified buffer
opt.cursorline = true                                   -- Enable highlighting of the current line
opt.expandtab = true                                    -- Use spaces instead of tabs
opt.laststatus = 3                                      -- global statusline
opt.linebreak = true                                    -- Wrap lines at convenient points
opt.list = true                                         -- Show hidden char like Tabs
opt.mouse = "a"                                         -- Enable mouse mode
opt.number = true                                       -- Print line number
opt.pumblend = 10                                       -- Popup blend
opt.pumheight = 10                                      -- Maximum number of entries in a popup
opt.relativenumber = true                               -- Relative line numbers
opt.scrolloff = 4                                       -- Lines of context
opt.shiftround = true                                   -- Round indent
opt.shiftwidth = 2                                      -- Size of an indent
opt.showmode = false                                    -- Dont show mode since we have a statusline
opt.sidescrolloff = 8                                   -- Columns of context
opt.signcolumn = "yes"                                  -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true                                    -- Don't ignore case with capitals
opt.smartindent = true                                  -- Insert indents automatically
opt.softtabstop = 2                                     -- How many spaces a tab key press will insert
opt.spelllang = { "en" }
opt.splitbelow = true                                   -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true                                   -- Put new windows right of current
opt.tabstop = 2                                         -- Number of spaces tabs count for
opt.termguicolors = true                                -- True color support
opt.undofile = true
opt.undolevels = 10000
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wrap = false          -- Disable line wrap

-- Set filetype to `bigfile` for files larger than 1.5 MB
-- Only vim syntax will be enabled (with the correct filetype)
-- LSP, treesitter and other ft plugins will be disabled.
-- mini.animate will also be disabled.
vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB
