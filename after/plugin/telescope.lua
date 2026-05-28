local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup{}
pcall(telescope.load_extension, 'fzf')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
