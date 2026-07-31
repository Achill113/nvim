return {
  -- UI
  "ryanoasis/vim-devicons",
  "folke/lsp-colors.nvim",
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  "xiyaowong/nvim-transparent",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  "Bekaboo/dropbar.nvim",
  "folke/which-key.nvim",
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  "lukas-reineke/indent-blankline.nvim",
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- File tree
  -- NERD_tree.vim sources `nerdtree_plugin/**` once, from the runtimepath as it
  -- stands at that moment, so anything decorating the tree has to already be on it.
  -- lazy's startup order is not stable, so without this the git flags and devicons
  -- glyphs went missing on a random subset of launches.
  {
    "preservim/nerdtree",
    dependencies = {
      "Xuyuanp/nerdtree-git-plugin",
      "tiagofumo/vim-nerdtree-syntax-highlight",
      "ryanoasis/vim-devicons",
    },
  },

  -- Editor utilities
  "editorconfig/editorconfig-vim",
  "sbdchd/neoformat",
  "numToStr/Comment.nvim",
  "caenrique/nvim-toggle-terminal",
  "dyng/ctrlsf.vim",
  "mbbill/undotree",

  -- Markdown
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    -- Calling mkdp#util#install here fails two ways: autoload/ isn't on the rtp
    -- yet (E117), and it spawns an async job that a headless build outlives.
    build = "cd app && sh ./install.sh",
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- Telescope
  "nvim-lua/plenary.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
  },

  -- ThePrimeagen
  "ThePrimeagen/harpoon",
  "ThePrimeagen/refactoring.nvim",

  -- Git
  "tpope/vim-fugitive",
  "akinsho/git-conflict.nvim",
  "lewis6991/gitsigns.nvim",

  -- Language-specific
  "HerringtonDarkholme/yats.vim",
  { "fatih/vim-go", build = ":GoUpdateBinaries" },

  -- LSP
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "b0o/schemastore.nvim",
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },

  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "saadparwaiz1/cmp_luasnip",

  -- Snippets
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",

  -- Formatting
  "stevearc/conform.nvim",

  -- DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "nvim-telescope/telescope-dap.nvim",
    },
  },

  -- UI: cmdline / messages / notifications
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("notify").setup({
        background_colour = "#000000",
      })
      require("noice").setup({
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
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
  },
}
