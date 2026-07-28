local fails, checks = 0, 0

local function check(label, ok, detail)
  checks = checks + 1
  if ok then
    print(string.format("  ok   %s", label))
  else
    fails = fails + 1
    print(string.format("  FAIL %s%s", label, detail and ("  <- " .. detail) or ""))
  end
end

print("\n== modules resolve ==")
for _, m in ipairs({
  "lazy",
  "copilot",
  "copilot.suggestion",
  "copilot-lsp",
  "copilot-lsp.nes",
  "codecompanion",
  "claudecode",
  "snacks",
  "cmp",
  "telescope",
  "harpoon.mark",
  "conform",
  "trouble",
  "noice",
}) do
  local ok, err = pcall(require, m)
  check("require " .. m, ok, ok and nil or tostring(err):sub(1, 90))
end

print("\n== commands registered ==")
-- Force the lazy-loaded AI plugins so their commands materialise.
require("lazy").load({ plugins = { "codecompanion.nvim", "claudecode.nvim", "copilot.lua" } })
local cmds = vim.api.nvim_get_commands({})
for _, c in ipairs({
  "CodeCompanion",
  "CodeCompanionChat",
  "CodeCompanionActions",
  "CodeCompanionCmd",
  "ClaudeCode",
  "ClaudeCodeSend",
  "ClaudeCodeDiffAccept",
  "Copilot",
  "Lazy",
}) do
  check(":" .. c, cmds[c] ~= nil)
end

print("\n== adapters wired ==")
local cc = require("codecompanion.config")
check("chat adapter == claude_code", cc.interactions.chat.adapter == "claude_code", tostring(cc.interactions.chat.adapter))
check("inline adapter == copilot", cc.interactions.inline.adapter == "copilot", tostring(cc.interactions.inline.adapter))
check("cmd adapter == copilot", cc.interactions.cmd.adapter == "copilot", tostring(cc.interactions.cmd.adapter))
check("diff enabled", cc.display.diff.enabled == true)

print("\n== keymaps ==")
local function has_map(mode, lhs)
  for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do
    if m.lhs == lhs then
      return true
    end
  end
  return false
end
-- mapleader is a literal backslash, so that is what shows up in lhs.
for _, spec in ipairs({
  { "n", "\\kk", "inline edit" },
  { "v", "\\kk", "inline edit selection" },
  { "n", "\\kc", "chat toggle" },
  { "n", "\\ka", "action palette" },
  { "v", "\\ke", "explain" },
  { "n", "\\ic", "claude toggle" },
  { "v", "\\is", "claude send selection" },
  { "n", "\\iy", "claude accept diff" },
  { "n", "\\a", "harpoon add_file still intact" },
}) do
  check(spec[1] .. " " .. spec[3], has_map(spec[1], spec[2]), spec[2])
end

print("\n== copilot NES ==")
-- nes keymaps are buffer-local and only attached once the copilot LSP client
-- connects, so assert the config survived validate() and that set_keymap binds.
local copilot_config = require("copilot.config")
check("nes enabled after validate", copilot_config.nes.enabled == true, vim.inspect(copilot_config.nes.enabled))
check("nes auto_trigger", copilot_config.nes.auto_trigger == true)
check("nes bound to <Tab>", copilot_config.nes.keymap.accept_and_goto == "<Tab>", vim.inspect(copilot_config.nes.keymap.accept_and_goto))
check("suggestion accept bound to <M-l>", copilot_config.suggestion.keymap.accept == "<M-l>")
check("suggestion auto_trigger", copilot_config.suggestion.auto_trigger == true)

local scratch = vim.api.nvim_create_buf(false, true)
require("copilot.nes").set_keymap(scratch)
local buf_has_tab = false
for _, m in ipairs(vim.api.nvim_buf_get_keymap(scratch, "n")) do
  if m.lhs == "<Tab>" then
    buf_has_tab = true
  end
end
check("set_keymap binds <Tab> buffer-locally", buf_has_tab)

print("\n== preserved behaviour ==")
check("mapleader is backslash", vim.g.mapleader == "\\", vim.inspect(vim.g.mapleader))
check("claude terminal_cmd keeps --dangerously-skip-permissions", (function()
  local ok, mod = pcall(require, "claudecode")
  return ok
    and mod.state
    and mod.state.config
    and mod.state.config.terminal_cmd == "claude --dangerously-skip-permissions"
end)())
check("copilot.vim is gone", not pcall(vim.fn.exists, "*copilot#Accept") or vim.fn.exists("*copilot#Accept") == 0)
check("no packer on rtp", not vim.o.runtimepath:match("pack/packer/"))
check("markdown-preview binary present", vim.fn.glob(vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app/bin/*") ~= "")

print(string.format("\n%d/%d checks passed\n", checks - fails, checks))
if fails > 0 then
  vim.cmd("cq")
end
