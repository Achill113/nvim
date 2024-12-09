local dap = require('dap')
local dapui = require('dapui')

local codelldb_path = os.getenv('CODELLDB_PATH')

if codelldb_path
then
  dap.adapters.lldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = codelldb_path,
      args = { '--port', '${port}' },
    }
  }

  dap.configurations.rust = {
    {
      name = "Launch Rust LLDB",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
  }

  dap.configurations.cpp = {
    {
      name = "Launch C++ LLDB",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
  }
end


-- Optionally add DAP UI for better visualization
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })

vim.api.nvim_set_keymap('n', '<F5>', '<cmd>lua require"dap".continue()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', '<cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F11>', '<cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F12>', '<cmd>lua require"dap".step_out()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>lua require"dap".toggle_breakpoint()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>B',
  '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dr', '<cmd>lua require"dap".repl.open()<CR>', { noremap = true, silent = true })
