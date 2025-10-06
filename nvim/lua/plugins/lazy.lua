-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  -- Color scheme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- Icons (used by many UIs)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  --File tree
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup {}
      end,
  },

  -- Visualize buffers as tabs
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

  -- Comment code
  {
    'terrortylor/nvim-comment',
    config = function()
      require("nvim_comment").setup({ create_mappings = false })
    end
  },

  -- Markdown preview (terminal glow)
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },

  -- Markdown preview (opens in browser)
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = { "markdown" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_browser = "/Applications/Firefox.app/Contents/MacOS/firefox"
    end,
  },


  -- LaTeX
  { "lervag/vimtex" },

  -- Snippets (UltiSnips for Gilles Castel LaTeX)
  { "SirVer/ultisnips" },
  { "quangnguyen30192/cmp-nvim-ultisnips" }, -- integrates UltiSnips with nvim-cmp

  -- LSP + completion + tools
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "stevearc/conform.nvim" },  -- formatter runner
  { "windwp/nvim-autopairs", config = true },

  -- Treesitter (better syntax/indent)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua","bash","python","julia","r","latex","bibtex",
          "markdown","markdown_inline","c","cpp","fortran","vim","vimdoc","query"
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- tmux integration (move across splits/panes)
  { "christoomey/vim-tmux-navigator" },

  -- Send code to a REPL in another tmux pane
  { "jpalardy/vim-slime" },

  -- Cite-keys for vimtex
  { "micangl/cmp-vimtex" },

  -- Autosave
  {
    "Pocco81/auto-save.nvim",
    config = function() require("auto-save").setup{} end
  },

})
