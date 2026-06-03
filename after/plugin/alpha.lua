local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

dashboard.section.buttons.val = {
  dashboard.button('e', '  New file', '<cmd>ene <BAR> startinsert<cr>'),
  dashboard.button('f', '  Find file', '<cmd>Telescope find_files<cr>'),
  dashboard.button('g', '  Live grep', '<cmd>Telescope live_grep<cr>'),
  dashboard.button('r', '  Recent files', '<cmd>Telescope oldfiles<cr>'),
  dashboard.button('c', '  Config', '<cmd>e $MYVIMRC<cr>'),
  dashboard.button('q', '  Quit', '<cmd>qa<cr>'),
}

alpha.setup(dashboard.config)
