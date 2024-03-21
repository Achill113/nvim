-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'ryanoasis/vim-devicons'
  use 'folke/lsp-colors.nvim'
  use 'preservim/nerdtree'
  use 'Xuyuanp/nerdtree-git-plugin'
  use 'ryanoasis/vim-devicons'
  use 'tiagofumo/vim-nerdtree-syntax-highlight'
  use 'eslint/eslint'
  use 'itchyny/lightline.vim'
  use 'itchyny/vim-gitbranch'
  use 'niklaas/lightline-gitdiff'
  use 'folke/tokyonight.nvim'
  use 'caenrique/nvim-toggle-terminal'
  use 'kien/ctrlp.vim'
  use 'dyng/ctrlsf.vim'
  use 'ruanyl/vim-sort-imports'
  use{'nvim-telescope/telescope-fzf-native.nvim', { run = 'make' }}
  use 'nvim-lua/plenary.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
			'nvim-treesitter/nvim-treesitter',
			run = function()
				local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
				ts_update()
			end}
  use("nvim-treesitter/playground")
  use("theprimeagen/harpoon")
  use("theprimeagen/refactoring.nvim")
  use("mbbill/undotree")

  use 'numToStr/Comment.nvim'
  use 'xiyaowong/nvim-transparent'
  use 'tpope/vim-fugitive'
  use{'codota/tabnine-nvim', { run = './dl_binaries.sh' }}
  use 'HerringtonDarkholme/yats.vim'
  use{'fatih/vim-go', { run = ':GoUpdateBinaries' }}

  use {
          'VonHeikemen/lsp-zero.nvim',
          branch = 'v1.x',
          requires = {
              -- LSP Support
              {'neovim/nvim-lspconfig'},
              {'williamboman/mason.nvim'},
              {'williamboman/mason-lspconfig.nvim'},

              -- Autocompletion
              {'hrsh7th/nvim-cmp'},
              {'hrsh7th/cmp-buffer'},
              {'hrsh7th/cmp-path'},
              {'saadparwaiz1/cmp_luasnip'},
              {'hrsh7th/cmp-nvim-lsp'},
              {'hrsh7th/cmp-nvim-lua'},

              -- Snippets
              {'L3MON4D3/LuaSnip'},
              {'rafamadriz/friendly-snippets'},
          }
    }

    use("tpope/vim-fugitive")

end)
