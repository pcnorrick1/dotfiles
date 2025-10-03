-- Viewer: prefer Zathura; if not installed, fallback to Sioyek
local viewer = vim.fn.executable("zathura") == 1 and "zathura" or "sioyek"

vim.g.vimtex_view_method = viewer
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_quickfix_mode = 0  -- cleaner quickfix
vim.g.vimtex_mappings_enabled = 1

-- UltiSnips settings (for LaTeX snippets)
vim.g.UltiSnipsExpandTrigger = "<C-j>"
vim.g.UltiSnipsJumpForwardTrigger  = "<C-j>"
vim.g.UltiSnipsJumpBackwardTrigger = "<C-k>"

-- Point UltiSnips to your snippet directories (we'll clone Gilles Castel below)
-- First entry is the one we’ll clone.
vim.g.UltiSnipsSnippetDirectories = { vim.fn.stdpath("config") .. "/UltiSnips", "UltiSnips" }

-- Handy VimTeX maps to remember:
-- \ll compile; \lv view; \lc clean; ]m/[m next/prev section; ]]/[[ next/prev env

