-- Browser preview (tables + mermaid via bundled mermaid.js)
vim.g.mkdp_filetypes = { 'markdown' }
vim.g.mkdp_auto_close = 0

vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', { desc = 'Toggle markdown preview in browser' })

-- In-editor rendering (headings, tables, code blocks, lists)
require('render-markdown').setup({
  render_modes = { 'n', 'c', 't' },
  file_types = { 'markdown' },
})
