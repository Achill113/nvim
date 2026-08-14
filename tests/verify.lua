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

print("\n== claude oauth token ==")
-- The token lives in the OS keyring, not the shell environment: exporting
-- CLAUDE_CODE_OAUTH_TOKEN from ~/.zshrc overrides whatever the `claude` CLI
-- itself is logged in as, so it has to reach the ACP adapter and nothing else.
local token = require("achill113.claude_token")
check("keyring command on macOS uses security", token.command("Darwin")[1] == "security", vim.inspect(token.command("Darwin")))
check("keyring command on Linux uses secret-tool", token.command("Linux")[1] == "secret-tool", vim.inspect(token.command("Linux")))
check("both query the same keyring entry", vim.tbl_contains(token.command("Darwin"), token.service) and vim.tbl_contains(token.command("Linux"), token.service), token.service)

local tmp = vim.fn.tempname()
vim.fn.writefile({ "sk-ant-from-file" }, tmp)
check("file fallback reads and trims", token.read_file(tmp) == "sk-ant-from-file", vim.inspect(token.read_file(tmp)))
vim.fn.delete(tmp)
check("missing fallback file is nil, not an error", token.read_file(tmp .. "-nope") == nil)

check("not exported into the shell environment", vim.env.CLAUDE_CODE_OAUTH_TOKEN == nil, "still exported — check ~/.zshrc")

local adapter = require("codecompanion.adapters").resolve("claude_code")
check("adapter resolves the token itself", type(adapter.env.CLAUDE_CODE_OAUTH_TOKEN) == "function", type(adapter.env.CLAUDE_CODE_OAUTH_TOKEN))
require("codecompanion.adapters.utils").get_env_vars(adapter, { timeout = 5000 })
local resolved = adapter.env_replaced.CLAUDE_CODE_OAUTH_TOKEN
check("keyring hands back a token", type(resolved) == "string" and resolved:match("^sk%-ant%-") ~= nil, vim.inspect(resolved and resolved:sub(1, 12)))

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
  { "n", "\\gf", "changed files picker" },
  { "n", "\\gd", "diff current file against HEAD" },
  { "n", "\\gs", "fugitive status still intact" },
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
-- The CodeCompanion ACP adapter authenticates by assigning vim.env, which is
-- process-wide: every terminal opened afterwards, including this one, would
-- inherit a token that overrides whatever the CLI is logged in as. `env -u`
-- puts the CLI back on its own credentials.
check("claude terminal_cmd keeps --dangerously-skip-permissions", (function()
  local ok, mod = pcall(require, "claudecode")
  return ok
    and mod.state
    and mod.state.config
    and mod.state.config.terminal_cmd == "env -u CLAUDE_CODE_OAUTH_TOKEN claude --dangerously-skip-permissions"
end)(), (function()
  local ok, mod = pcall(require, "claudecode")
  return ok and mod.state and mod.state.config and tostring(mod.state.config.terminal_cmd) or "no config"
end)())

local acp_adapter = require("codecompanion.adapters").resolve("claude_code")
require("codecompanion.adapters.utils").get_env_vars(acp_adapter, { timeout = 5000 })
acp_adapter.handlers.auth(acp_adapter)
check("chat auth leaks the token into vim.env, hence the env -u above", vim.env.CLAUDE_CODE_OAUTH_TOKEN ~= nil)
vim.env.CLAUDE_CODE_OAUTH_TOKEN = nil
check("copilot.vim is gone", not pcall(vim.fn.exists, "*copilot#Accept") or vim.fn.exists("*copilot#Accept") == 0)
check("no packer on rtp", not vim.o.runtimepath:match("pack/packer/"))
check("markdown-preview binary present", vim.fn.glob(vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app/bin/*") ~= "")

print("\n== treesitter queries ==")
-- nvim-treesitter symlinks site/queries/<lang> at its own runtime/queries/<lang>.
-- Moving or renaming the plugin directory breaks every link silently: parsers keep
-- loading, so highlighting just quietly stops contributing and folds disappear.
local qdir = vim.fn.stdpath("data") .. "/site/queries"
local broken = {}
for name, kind in vim.fs.dir(qdir) do
  if kind == "link" and vim.uv.fs_stat(qdir .. "/" .. name) == nil then
    table.insert(broken, name)
  end
end
check("no broken query symlinks", #broken == 0, table.concat(broken, ", "))

local missing = {}
for _, lang in ipairs({ "lua", "go", "rust", "typescript", "tsx", "javascript", "json", "yaml", "html", "css", "bash", "c", "markdown" }) do
  for _, q in ipairs({ "highlights", "folds" }) do
    local ok, res = pcall(vim.treesitter.query.get, lang, q)
    if not (ok and res) then
      table.insert(missing, lang .. "/" .. q)
    end
  end
end
check("highlights+folds queries resolve", #missing == 0, table.concat(missing, ", "))

print("\n== folding ==")
check("foldmethod is expr", vim.o.foldmethod == "expr", vim.o.foldmethod)
check("foldexpr uses treesitter", vim.o.foldexpr == "v:lua.vim.treesitter.foldexpr()", vim.o.foldexpr)
check("foldlevelstart keeps files open", vim.o.foldlevelstart == 99, tostring(vim.o.foldlevelstart))

-- Editing a real file, because fold levels are computed lazily and a synthetic
-- buffer in a headless session never triggers the evaluation.
local gofile = vim.fn.tempname() .. ".go"
vim.fn.writefile({
  "package main",
  "",
  "func add(a, b int) int {",
  "\treturn a + b",
  "}",
}, gofile)
vim.cmd.edit(gofile)
vim.wait(3000, function()
  return vim.fn.foldlevel(3) > 0
end, 100)
check("go function is foldable", vim.fn.foldlevel(3) > 0, "foldlevel(3)=" .. vim.fn.foldlevel(3))
vim.fn.delete(gofile)

-- Last, because it changes the cwd and leaves the tree window current.
print("\n== nerdtree ==")
-- vim-devicons hangs its bracket-conceal syntax off FileType nerdtree. Neovim's
-- default `syntax on` registers the syntaxset autocmd after every user script, so
-- under lazy it fires last and `syn clear`s those matches straight back out again.
-- Assert the rendered result rather than the autocmd order.
-- Resolved, because on macOS tempname() sits under the /var -> /private/var
-- symlink and the git plugin keys its status map off the real workdir path.
local repo = vim.fn.tempname()
vim.fn.mkdir(repo, "p")
repo = vim.uv.fs_realpath(repo)
local function git(...)
  vim.fn.system(vim.list_extend({ "git", "-C", repo, "-c", "user.email=t@t", "-c", "user.name=t" }, { ... }))
end
git("init", "-q")
vim.fn.writefile({ "one" }, repo .. "/tracked.txt")
git("add", "-A")
git("commit", "-qm", "init")
vim.fn.writefile({ "one", "two" }, repo .. "/tracked.txt")
vim.fn.writefile({ "new" }, repo .. "/untracked.txt")

vim.cmd.cd(repo)
vim.cmd("NERDTree")
check("nerdtree window is current", vim.bo.filetype == "nerdtree", vim.bo.filetype)
check(
  "devicons bracket conceal survives the syntax load",
  vim.fn.execute("silent! syn list hideBracketsInNerdTree"):match("NERDTreeFlags") ~= nil
)
-- 3 is devicons' value; nerdtree's own syntax file leaves 2 behind when it wins.
check("devicons set conceallevel last", vim.wo.conceallevel == 3, tostring(vim.wo.conceallevel))

-- Both decorators reach the tree through nerdtree's `runtime! nerdtree_plugin/**`,
-- which only sees what is already on the runtimepath when NERD_tree.vim is sourced.
check("git plugin was picked up by nerdtree", vim.g.loaded_nerdtree_git_status == 1)
check("devicons nerdtree integration is on", vim.g.webdevicons_enable_nerdtree == 1)
check("devicons flag listener exists", vim.fn.exists("*NERDTreeWebDevIconsRefreshListener") == 1)

-- The rendered flag block itself. The git half arrives from an async `git status`
-- job, so the first render is always blank and this has to poll. \a is the
-- delimiter nerdtree puts between the flag block and the node name.
local function tree_line(name)
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    if line:find("\a" .. name, 1, true) then
      return line
    end
  end
  return ""
end
local glyph = vim.fn.WebDevIconsGetFileTypeSymbol("tracked.txt", 0)
local tracked, untracked = "", ""
check("git status flags render", vim.wait(10000, function()
  tracked, untracked = tree_line("tracked.txt"), tree_line("untracked.txt")
  return tracked:match("✹") ~= nil and untracked:match("✭") ~= nil
end, 100), tracked .. untracked)
check("devicons glyph renders alongside them", tracked:find(glyph, 1, true) ~= nil, tracked)
vim.fn.delete(repo, "rf")

print(string.format("\n%d/%d checks passed\n", checks - fails, checks))
if fails > 0 then
  vim.cmd("cq")
end
