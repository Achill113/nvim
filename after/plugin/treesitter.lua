local parsers = {
  'vimdoc', 'vim', 'lua', 'c', 'rust',
  'javascript', 'typescript', 'tsx', 'jsx',
  'json', 'yaml', 'html', 'css', 'bash', 'go',
}

require('nvim-treesitter').install(parsers)

vim.api.nvim_create_autocmd('FileType', {
  pattern = parsers,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
