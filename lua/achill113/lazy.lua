-- Neovim's own `syntax on` runs after every user script, so the syntaxset FileType
-- autocmd would be registered after any plugin lazy sources here. It ends up last in
-- the FileType chain and its `syn clear` wipes syntax that plugins add on the same
-- event — vim-devicons' NERDTree bracket conceal, for one. Packer never hit this
-- because pack/*/start is loaded after startup, not from inside init.lua.
vim.cmd("syntax enable")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  -- Plugin config lives in after/plugin/, which runs once init.lua returns, so
  -- anything without an explicit event/cmd/keys trigger has to be loaded by then.
  defaults = { lazy = false },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "zipPlugin" },
    },
  },
})
