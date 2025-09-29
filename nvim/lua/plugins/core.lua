return {
  -- Lua utils (dependency for many plugins)
  { "nvim-lua/plenary.nvim", lazy = true },

  -- which-key: discover keymaps
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} }, -- shows a popup of mappings

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Buffers"   },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Help tags" },
    },
    opts = {
      defaults = {
        mappings = {
          i = { ["<C-h>"] = "which_key" }, -- show Telescope key hints
        },
      },
    },
  },

  -- Native FZF sorter for Telescope (faster & better scoring)
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function() require("telescope").load_extension("fzf") end,
  },

  -- Treesitter for syntax & motion (install common languages)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = { "lua", "markdown", "markdown_inline", "python", "julia", "latex" },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- Obsidian integration (community-maintained fork, active in 2025)
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        { name = "academia", path = "~/academia/notes" },
      },
      notes_subdir = "inbox",           -- new notes land in ~/academia/notes/inbox
      daily_notes = { folder = "contexts/dailies" },
      templates = {
        folder = ".templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      attachments = { img_folder = "attachments/img" },
      ui = { enable = true },
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>",           desc = "Obsidian: new note" },
      { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>",   desc = "Obsidian: quick switch" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>",        desc = "Obsidian: search notes" },
      { "<leader>ot", "<cmd>ObsidianToday<cr>",         desc = "Obsidian: today" },
      { "<leader>oT", "<cmd>ObsidianTemplate<cr>",      desc = "Obsidian: insert template" },
      { "<leader>oc", "<cmd>ObsidianToggleCheckbox<cr>",desc = "Obsidian: toggle checkbox" },
      { "gf",         "<cmd>ObsidianFollowLink<cr>",    desc = "Obsidian: follow link" },
    },
  },
}