-- AI layers, roughly mapping onto what Cursor gives you:
--   copilot.lua      ghost-text completion + next-edit prediction (Tab)
--   codecompanion    inline edits (<leader>kk) and a chat buffer (<leader>kc)
--   claudecode.nvim  the full agent, over the same IDE protocol VS Code uses

return {
  -- Inline completion as you type, plus Next Edit Suggestions: after an edit,
  -- <Tab> in normal mode jumps to and applies the next predicted change.
  {
    "zbirenbaum/copilot.lua",
    dependencies = { "copilotlsp-nvim/copilot-lsp" },
    cmd = "Copilot",
    event = "InsertEnter",
    init = function()
      vim.g.copilot_nes_debounce = 500
    end,
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          accept = "<M-l>",
          accept_word = "<M-w>",
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      nes = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          -- Passes through to the original <Tab> when nothing is pending.
          accept_and_goto = "<Tab>",
          accept = false,
          dismiss = false,
        },
      },
      filetypes = {
        markdown = true,
        gitcommit = true,
        yaml = true,
      },
    },
  },

  {
    "copilotlsp-nvim/copilot-lsp",
    config = function()
      require("copilot-lsp").setup({
        nes = {
          move_count_threshold = 3,
        },
      })
    end,
  },

  -- Cursor's Cmd+K and Cmd+L. Inline edits land as a reviewable diff in the
  -- buffer; g2 accepts a hunk, g3 rejects it, } and { move between them.
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
    },
    init = function()
      vim.cmd([[cab cc CodeCompanion]])

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { noremap = true, desc = desc })
      end

      -- No <cr>: the cmdline stays open so you type the instruction.
      map("n", "<leader>kk", ":CodeCompanion ", "AI: inline edit")
      map("v", "<leader>kk", ":'<,'>CodeCompanion ", "AI: inline edit selection")

      map({ "n", "v" }, "<leader>kc", "<cmd>CodeCompanionChat Toggle<cr>", "AI: toggle chat")
      map({ "n", "v" }, "<leader>ka", "<cmd>CodeCompanionActions<cr>", "AI: action palette")
      map("v", "<leader>kd", "<cmd>CodeCompanionChat Add<cr>", "AI: add selection to chat")

      map("v", "<leader>ke", ":'<,'>CodeCompanion /explain<cr>", "AI: explain selection")
      map("v", "<leader>kf", ":'<,'>CodeCompanion /fix<cr>", "AI: fix selection")
      map("v", "<leader>kt", ":'<,'>CodeCompanion /tests<cr>", "AI: generate tests")
      map("v", "<leader>kl", ":'<,'>CodeCompanion /lsp<cr>", "AI: explain diagnostics")
      map("n", "<leader>kg", "<cmd>CodeCompanion /commit<cr>", "AI: commit message")
      map("n", "<leader>km", "<cmd>CodeCompanionCmd<cr>", "AI: generate an ex command")
    end,
    opts = {
      interactions = {
        -- Chat goes through Claude Code over ACP, so project skills in .claude/
        -- and your configured MCP servers are available in the conversation.
        chat = { adapter = "claude_code" },
        -- Inline and cmd only accept HTTP adapters, so they ride the Copilot
        -- subscription that's already authenticated on this machine.
        inline = { adapter = "copilot" },
        cmd = { adapter = "copilot" },
      },
      display = {
        action_palette = { provider = "telescope" },
        chat = {
          window = {
            layout = "vertical",
            position = "right",
            width = 0.4,
          },
        },
        diff = { enabled = true },
      },
    },
  },

  -- Replaces greggh/claude-code.nvim. That one just ran `claude` in a split;
  -- this speaks the WebSocket IDE protocol, so Claude tracks the active buffer
  -- and selection, and its edits arrive as native diff windows you can amend.
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeStatus",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>ic", "<cmd>ClaudeCode<cr>", desc = "Claude: toggle" },
      { "<leader>if", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude: focus" },
      { "<leader>iC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude: continue" },
      { "<leader>ir", "<cmd>ClaudeCode --resume<cr>", desc = "Claude: resume" },
      { "<leader>im", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Claude: select model" },
      { "<leader>ib", "<cmd>ClaudeCodeAdd %<cr>", desc = "Claude: add buffer to context" },
      { "<leader>is", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude: send selection" },
      { "<leader>iy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude: accept diff" },
      { "<leader>in", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude: deny diff" },
      { "<leader>iq", "<cmd>ClaudeCodeCloseAllDiffs<cr>", desc = "Claude: close all diffs" },
    },
    opts = {
      terminal_cmd = "claude --dangerously-skip-permissions",
      track_selection = true,
      terminal = {
        split_side = "right",
        split_width_percentage = 0.40,
        provider = "snacks",
        auto_close = true,
      },
      diff_opts = {
        layout = "vertical",
        open_in_new_tab = false,
        keep_terminal_focus = false,
      },
    },
  },

  { "folke/snacks.nvim", priority = 900, opts = {} },
}
