require('dropbar').setup()

vim.keymap.set('n', '<leader>;', function()
  require('dropbar.api').pick()
end, { desc = 'Pick from breadcrumb' })
