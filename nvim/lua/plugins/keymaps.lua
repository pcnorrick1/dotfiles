-- telescope
vim.keymap.set("n", "<leader>fs", ":Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fp", ":Telescope git_files<cr>")
vim.keymap.set("n", "<leader>fz", ":Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<cr>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<cr>")


--tree
vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<cr>")

-- nvim-comment
vim.keymap.set({"n", "v"}, "<leader>/", ":CommentToggle<cr>")

-- Markdown preview (glow)
vim.keymap.set("n","<leader>mpg", ":Glow<CR>")

-- Markdown preview (browser)
vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>")

-- Rename Variables
vim.keymap.set("n", "<leader>rn", ":IncRename<CR>")

--------------
-- REPL Workflows
--------------
-- <leader>ss  Send current line
-- <leader>sp  Send visual selection or paragraph
-- <leader>sf  Send entire file

local function send_current_line()
  vim.cmd("SlimeSend")
end

local function send_visual_selection()
  vim.cmd("SlimeSend")
end

local function send_entire_file()
  vim.cmd("normal! ggVG")
  vim.cmd("SlimeSend")
end

-- Shared send commands
vim.keymap.set("n", "<leader>ss", send_current_line, { desc = "Send current line to REPL" })
vim.keymap.set("v", "<leader>sp", send_visual_selection, { desc = "Send selection to REPL" })
vim.keymap.set("n", "<leader>sf", send_entire_file, { desc = "Send entire file to REPL" })
