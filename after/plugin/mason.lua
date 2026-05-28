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
    "rust_analyzer",
    "angularls",
    "eslint",
    "jsonls",
  },
  automatic_installation = true,
})
