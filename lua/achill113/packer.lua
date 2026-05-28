-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- UI
  use 'ryanoasis/vim-devicons'
  use 'folke/lsp-colors.nvim'
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'xiyaowong/nvim-transparent'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- File tree
  use 'preservim/nerdtree'
  use 'Xuyuanp/nerdtree-git-plugin'
  use 'tiagofumo/vim-nerdtree-syntax-highlight'

  -- Editor utilities
  use 'editorconfig/editorconfig-vim'
  use 'sbdchd/neoformat'
  use 'numToStr/Comment.nvim'
  use 'caenrique/nvim-toggle-terminal'
  use 'dyng/ctrlsf.vim'
  use 'mbbill/undotree'

  -- Telescope
  use 'nvim-lua/plenary.nvim'
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    run = ':TSUpdate',
  }

  -- Theprimeagen
  use 'theprimeagen/harpoon'
  use 'theprimeagen/refactoring.nvim'

  -- Git
  use 'tpope/vim-fugitive'
  use 'akinsho/git-conflict.nvim'
  use 'lewis6991/gitsigns.nvim'

  -- AI
  use {
    'github/copilot.vim',
    { branch = 'release' },
  }
  use {
    'coder/claudecode.nvim',
    requires = { 'folke/snacks.nvim' },
    config = function()
      require('claudecode').setup()
    end,
  }

  -- Language-specific
  use 'HerringtonDarkholme/yats.vim'
  use { 'fatih/vim-go', { run = ':GoUpdateBinaries' } }

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'b0o/schemastore.nvim'
  use {
    'pmizio/typescript-tools.nvim',
    requires = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      require('typescript-tools').setup {}
    end,
  }

  -- Completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'saadparwaiz1/cmp_luasnip'

  -- Snippets
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'

  -- Formatting
  use 'stevearc/conform.nvim'

  -- DAP
  use {
    'mfussenegger/nvim-dap',
    requires = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'nvim-telescope/telescope-dap.nvim',
    },
  }

  -- UI: cmdline / messages / notifications
  use {
    'folke/noice.nvim',
    requires = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('notify').setup({
        background_colour = '#000000',
      })
      require('noice').setup({
        cmdline = {
          enabled = true,
          view = 'cmdline_popup',
        },
        messages = { enabled = true },
        popupmenu = { enabled = true },
        lsp = {
          progress = { enabled = true },
          hover = { enabled = true },
          signature = { enabled = true },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          lsp_doc_border = true,
        },
      })
    end,
  }
end)
