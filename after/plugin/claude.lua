local map = vim.keymap.set

-- Main commands
map("n", "<leader>ic", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
map("n", "<leader>if", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
map("n", "<leader>ir", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
map("n", "<leader>iC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
map("n", "<leader>im", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
map("n", "<leader>ib", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })

-- Visual mode send
map("v", "<leader>is", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })

-- Diff management
map("n", "<leader>ia", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
map("n", "<leader>id", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

-- File tree integration (filetype-specific)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
  callback = function()
    map("n", "<leader>is", "<cmd>ClaudeCodeTreeAdd<cr>", { buffer = true, desc = "Add file" })
  end,
})
