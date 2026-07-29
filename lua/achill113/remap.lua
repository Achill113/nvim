vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<C-l>", ":tabn<CR>")
vim.keymap.set("n", "<C-h>", ":tabp<CR>")
vim.keymap.set("n", "<leader>n", ":tabnew<CR>")
vim.keymap.set("n", "<leader>c", ":tabc<cr>")

vim.keymap.set("n", "<leader>x", ":%s/\\r//<CR>")

vim.keymap.set("n", "<esc>", ":noh<CR>")

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
vim.keymap.set("n", "Q", "<nop>")

-- Moves
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- NERDTree
vim.keymap.set("n", "<leader>tf", ":NERDTreeFocus<CR>")
vim.keymap.set("n", "<C-n>", ":NERDTree<CR>")
vim.keymap.set("n", "<C-t>", ":NERDTreeToggle<CR>")
vim.keymap.set("n", "<C-o>", ":NERDTreeFind<CR>")

-- Terminal
vim.api.nvim_set_keymap('n', '<leader>t', ':terminal<CR>', { noremap = true, silent = true })

-- Reload config. Clearing package.loaded is what makes this work at all —
-- init.lua only requires achill113, so a bare dofile hits the module cache and
-- re-executes nothing. achill113.lazy stays cached on purpose: re-running
-- lazy.setup() is unsupported and warns. after/plugin/ is not re-sourced either,
-- so LSP, cmp and the AI plugins still need a restart.
function _G.ReloadNvimConfig()
  for name in pairs(package.loaded) do
    if name:match("^achill113") and name ~= "achill113.lazy" then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC or vim.fn.stdpath('config') .. '/init.lua')
  vim.notify("Neovim config reloaded", vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>rc', ReloadNvimConfig, { desc = "Reload config" })
