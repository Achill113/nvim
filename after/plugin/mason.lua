-- =========================
-- Mason
-- =========================
require("mason").setup()

-- =========================
-- Mason ↔ LSP bridge
-- =========================
require("mason-lspconfig").setup({
  ensure_installed = {
    "cssls",
    "html",
    "dockerls",
    "gopls",
    "tailwindcss",
    "vimls",
    "omnisharp",
    "rust_analyzer",
    "angularls",
    "eslint",
    "ruby_lsp",
    "jsonls",
  },
  automatic_installation = true,
})
