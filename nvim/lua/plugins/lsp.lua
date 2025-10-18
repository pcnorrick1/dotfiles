-- Completion setup (nvim-cmp + UltiSnips)
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      -- UltiSnips integration
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<C-j>"]     = cmp.mapping.select_next_item(cmp_select),
    ["<C-k>"]     = cmp.mapping.select_prev_item(cmp_select),
  }),
  sources = cmp.config.sources({
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "ultisnips" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})

cmp.setup.filetype("tex", {
    sources = cmp.config.sources({
        { name = "vimtex" },
        { name = "ultisnips" },
        { name = "path" },
    }, {
        { name = "buffer" },
    })
})

-- Markdown: cite keys from your local + global bibs
cmp.setup.filetype("markdown", {
  sources = cmp.config.sources({
    {
      name = "bibtex",
      option = {
        bibliography = {
          "refs.bib",  -- project-local (or symlink)
          os.getenv("HOME") .. "/academia/library/master.bib", -- optional global
        },
      },
    },
    { name = "path" },
  }, { { name = "buffer" } }),
})


-- Capabilities for all LSP servers
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure servers (new API)
local function setup_lsp(server, opts)
  opts = opts or {}
  opts.capabilities = capabilities
  vim.lsp.config(server, opts)
  vim.lsp.enable(server)
end

-- Python
setup_lsp("pyright")
setup_lsp("ruff") -- linting/formatting with Ruff (replaces ruff_lsp)

-- Julia
setup_lsp("julials")

-- R
setup_lsp("r_language_server")

-- C / C++
setup_lsp("clangd")

-- Fortran
setup_lsp("fortls")

-- Markdown
setup_lsp("marksman")

-- Formatter integration (conform.nvim)
require("conform").setup({
  formatters_by_ft = {
    python   = { "isort", "black" },
    lua      = { "stylua" },
    markdown = {},
    tex      = { "latexindent" },
  },
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 1000,
  },
})
