vim.cmd("colorscheme catppuccin-macchiato") -- set color theme
vim.cmd("colorscheme catppuccin-macchiato") -- set color theme

vim.g.python3_host_prog = os.getenv("HOME") .. "/.venvs/nvim/bin/python"

vim.opt.termguicolors = true --bufferline
require("bufferline").setup{} --bufferline

-- tmux navigator works out-of-the-box with <C-hjkl>

-- Send code to a REPL in another tmux pane
vim.g.slime_target = "tmux"
-- By default it sends to the last active tmux pane
-- Use :SlimeConfig to pin a pane if you want
--
