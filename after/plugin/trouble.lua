require('trouble').setup()

vim.keymap.set('n', '<leader>qq', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (workspace)' })
vim.keymap.set('n', '<leader>qb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Diagnostics (buffer)' })
vim.keymap.set('n', '<leader>qs', '<cmd>Trouble symbols toggle<cr>', { desc = 'Symbols' })
vim.keymap.set('n', '<leader>ql', '<cmd>Trouble loclist toggle<cr>', { desc = 'Loclist' })
vim.keymap.set('n', '<leader>qf', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix' })
