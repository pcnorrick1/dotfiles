vim.g.vimtex_view_method = "sioyek" 
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_progname = "nvr"
vim.g.vimtex_quickfix_mode = 0  -- cleaner quickfix
vim.g.vimtex_mappings_enabled = 1
vim.g.vimtex_syntax_enabled = 0 -- gives syntax highlighting to treesitter

-- UltiSnips settings (for LaTeX snippets)
vim.g.UltiSnipsExpandTrigger = "<C-j>"
vim.g.UltiSnipsJumpForwardTrigger  = "<C-j>"
vim.g.UltiSnipsJumpBackwardTrigger = "<C-k>"

-- Point UltiSnips to your snippet directories (we'll clone Gilles Castel below)
-- First entry is the one we’ll clone.
vim.g.UltiSnipsSnippetDirectories = { vim.fn.stdpath("config") .. "/UltiSnips", "UltiSnips" }

-- Handy VimTeX maps to remember:
-- \ll compile; \lv view; \lc clean; ]m/[m next/prev section; ]]/[[ next/prev env

