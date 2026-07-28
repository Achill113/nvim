# Neovim Configuration

A modern, batteries-included Neovim setup focused on TypeScript, Go, Rust, and Ruby development with native LSP, treesitter, AI assistance, and a polished UI.

---

## Requirements

- **Neovim 0.11+** (tested on 0.12.x) — CodeCompanion requires 0.11
- **Git**
- **Node.js 22+** — Claude Code CLI, the ACP bridge, markdown preview, copilot
- **A C compiler** (`gcc` on Linux/Windows, Xcode CLT on macOS) — treesitter parsers
- **`ripgrep`** and **`fd`** — telescope live grep, find files, CodeCompanion's `grep_search`
- **A Nerd Font** — icons in lualine / bufferline / nerdtree / alpha
- **`make`** — for plugin build steps
- **`curl`** — CodeCompanion's HTTP adapters

### AI prerequisites

- **GitHub Copilot subscription** — drives ghost-text completion, Next Edit Suggestions, and CodeCompanion's inline edits. Authenticate once with `:Copilot auth`.
- **`claude` CLI** — the agentic integration. Must be on `$PATH`.
- **Claude subscription** — backs the CodeCompanion chat buffer via ACP.
- **`@agentclientprotocol/claude-agent-acp`** — the ACP bridge the chat adapter spawns:
  ```sh
  npm install -g @agentclientprotocol/claude-agent-acp
  ```

### Optional

- **`cargo` / `rustup`** — only if you use a plugin that builds Rust extensions
- **`codelldb`** — set `CODELLDB_PATH` env var to enable Rust/C++ debugging

---

## Installation

```sh
# 1. Clone into ~/.config/nvim
git clone https://github.com/Achill113/nvim.git ~/.config/nvim

# 2. Install the ACP bridge for the Claude-backed chat buffer
npm install -g @agentclientprotocol/claude-agent-acp

# 3. First launch — lazy.nvim bootstraps itself and installs everything
nvim
```

lazy.nvim clones itself on first run, so there is no manager to install by hand.
Watch the `:Lazy` window until every plugin is green, then restart.

```vim
" 4. Install LSP servers (mason-lspconfig auto-installs the ensure_installed list,
"    but you can add more interactively)
:Mason

" 5. One-time Copilot auth, if you have not done it on this machine before
:Copilot auth
```

Finally, authorize the chat buffer against your Claude subscription. This is an
interactive browser flow, so it has to be run from a shell:

```sh
claude setup-token
```

Export the token it prints so the ACP adapter can pick it up — it is read from
the environment, deliberately, so no credential ends up in this repo:

```sh
# ~/.zshrc
export CLAUDE_CODE_OAUTH_TOKEN="..."
```

Restart Neovim one more time and everything should be ready.

---

## Directory Layout

```
~/.config/nvim/
├── init.lua                       # entry point — just requires achill113
├── lua/achill113/
│   ├── init.lua                   # requires set + remap + lazy
│   ├── set.lua                    # leader, vim.opt options, global vim.g flags
│   ├── remap.lua                  # global keymaps (no plugin dependency)
│   └── lazy.lua                   # bootstraps lazy.nvim and imports lua/plugins
├── lua/plugins/                   # plugin manifest (lazy.nvim specs)
│   ├── init.lua                   # everything non-AI
│   └── ai.lua                     # copilot, codecompanion, claudecode + their config
├── after/plugin/                  # per-plugin setup, loaded after the plugin itself
│   ├── alpha.lua                  # dashboard
│   ├── bufferline.lua             # tab strip
│   ├── colors.lua                 # catppuccin colorscheme
│   ├── comment.lua                # Comment.nvim
│   ├── debugger.lua               # nvim-dap + dap-ui
│   ├── dropbar.lua                # winbar breadcrumbs
│   ├── fugitive.lua               # :Git mapping
│   ├── git.lua                    # gitsigns + git-conflict
│   ├── harpoon.lua                # harpoon nav
│   ├── indent-blankline.lua       # indent guides
│   ├── lsp.lua                    # LSP servers, cmp, conform formatting
│   ├── lualine.lua                # statusline with branch-wide diff
│   ├── markdown.lua               # markdown-preview + render-markdown
│   ├── mason.lua                  # mason-lspconfig ensure_installed
│   ├── telescope.lua              # fuzzy finder + fzf extension
│   ├── treesitter.lua             # parser list + highlight autocmd
│   ├── trouble.lua                # diagnostic panels
│   ├── typescript.lua             # typescript-tools setup
│   ├── undotree.lua               # undotree toggle
│   └── which-key.lua              # leader popup
└── lazy-lock.json                 # pinned plugin revisions — commit this
```

Plugin **specs** live in `lua/plugins/`; plugin **config** stays in `after/plugin/`,
which is why most specs have no `config` block. `after/plugin/` is sourced by Neovim
once `init.lua` returns, so anything configured there must already be loaded —
hence `defaults = { lazy = false }` in `lua/achill113/lazy.lua`. The AI plugins are
the exception: they lazy-load on `event`/`cmd`/`keys` and carry their own config in
`lua/plugins/ai.lua`.

---

## Keymap Reference

Leader is **backslash** (`\`), set explicitly in `set.lua`. So `<leader>ff` is typed
`\ff`. It has to be assigned before lazy.nvim loads, or plugin `keys` specs resolve
against the wrong prefix.

### Navigation

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>pv` | n | Open netrw (`:Ex`) |
| `<C-l>` / `<C-h>` | n | Next / previous tab |
| `<leader>n` / `<leader>c` | n | New tab / close tab |
| `<leader><leader>` | n | Source current file |
| `J` | n | Join lines, keep cursor in place |
| `<C-d>` / `<C-u>` | n | Half-page down / up, centered |
| `n` / `N` | n | Search next / prev, centered |
| `<A-j>` / `<A-k>` | n/i/v | Move lines down / up |
| `<esc>` | n | Clear search highlight |

### Yank / paste / delete

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>p` | x | Paste without yanking the replaced text |
| `<leader>y` | n/v | Yank to system clipboard |
| `<leader>Y` | n | Yank line to system clipboard |
| `<leader>d` | n/v | Delete to black hole register |

### File tree (NERDTree)

| Key | Action |
| --- | --- |
| `<leader>tf` | Focus NERDTree |
| `<C-n>` | Open NERDTree |
| `<C-t>` | Toggle NERDTree |
| `<C-f>` | Find current file in NERDTree |

### Telescope

| Key | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<C-p>` | Git files |

### LSP (active in any buffer with an LSP attached)

| Key | Mode | Action |
| --- | --- | --- |
| `gd` | n | Go to definition |
| `gr` / `<leader>rr` | n | Find references |
| `K` | n | Hover |
| `<leader>rn` / `<F2>` | n | Rename symbol |
| `<C-a>` | n/v | Code action |
| `<C-h>` | i | Signature help |
| `<leader>f` | n | Format buffer |
| `<leader>vd` | n | Open diagnostic float |
| `[d` / `]d` | n | Prev / next diagnostic |
| `<leader>vws` | n | Workspace symbol |

### Trouble (diagnostics panel)

| Key | Action |
| --- | --- |
| `<leader>qq` | Workspace diagnostics |
| `<leader>qb` | Buffer diagnostics |
| `<leader>qs` | Symbols |
| `<leader>ql` | Loclist |
| `<leader>qf` | Quickfix |

### Completion (nvim-cmp, insert mode)

| Key | Action |
| --- | --- |
| `<C-n>` / `<C-p>` | Next / prev item |
| `<Tab>` | Next item if the menu is open, else accept the Copilot suggestion |
| `<S-Tab>` | Prev item when menu is visible |
| `<C-y>` | Confirm (auto-select if none selected) |
| `<CR>` | Confirm (no auto-select) |
| `<C-Space>` | Force complete |
| `<Esc>` | Abort completion menu |

`<Tab>` prefers nvim-cmp so the existing behaviour is unchanged; Copilot is only
accepted when no completion menu is open. To make Copilot win instead, swap the
first two branches of the `<Tab>` mapping in `after/plugin/lsp.lua`. `<M-l>` always
accepts the Copilot suggestion regardless of what the menu is doing.

### Copilot (inline completion)

| Key | Mode | Action |
| --- | --- | --- |
| `<M-l>` | i | Accept the whole suggestion |
| `<M-w>` | i | Accept one word |
| `<M-]>` / `<M-[>` | i | Next / previous suggestion |
| `<C-]>` | i | Dismiss |
| `<Tab>` | n | Accept the Next Edit Suggestion and jump to it |

Suggestions auto-trigger as you type. **Next Edit Suggestions** are the predictive
part: after you make a change, Copilot proposes the *next* edit implied by it —
often in a different place in the file — and `<Tab>` in normal mode jumps there and
applies it. When nothing is pending, `<Tab>` falls through to its normal meaning.
Pending suggestions clear themselves after 3 cursor moves.

### Git

| Key | Action |
| --- | --- |
| `<leader>gs` | Open fugitive (`:Git`) |
| `<C-b>` | Toggle current-line blame (gitsigns) |

### Harpoon

| Key | Action |
| --- | --- |
| `<leader>a` | Add current file |
| `<C-e>` | Toggle quick menu |
| `<C-Up/Right/Down/Left>` | Jump to slot 1 / 2 / 3 / 4 |

### CodeCompanion — write code *with* AI (`<leader>k`)

This is the Cursor `Cmd+K` / `Cmd+L` layer: small, fast, reviewable edits, so you
don't have to escalate every change to the full agent.

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>kk` | n | Inline edit — leaves the cmdline open, type the instruction |
| `<leader>kk` | v | Inline edit scoped to the selection |
| `<leader>kc` | n/v | Toggle the chat buffer |
| `<leader>ka` | n/v | Action palette (every prompt, in telescope) |
| `<leader>kd` | v | Add the selection to the open chat |
| `<leader>ke` | v | Explain the selection |
| `<leader>kf` | v | Fix the selection |
| `<leader>kt` | v | Generate unit tests (lands in a new buffer) |
| `<leader>kl` | v | Explain the LSP diagnostics on the selection |
| `<leader>kg` | n | Write a commit message from the staged diff |
| `<leader>km` | n | Generate an ex command from a description |

Inline edits arrive as a **diff in your buffer**, not as text to copy:

| Key | Action |
| --- | --- |
| `g2` | Accept the hunk |
| `g3` | Reject the hunk |
| `g1` | Accept everything in this buffer from here on |
| `}` / `{` | Next / previous hunk |
| `q` | Stop an in-flight request |

`cc` is abbreviated to `CodeCompanion` on the cmdline, so `:cc make this async`
works, and `:'<,'>cc adapter=anthropic ...` overrides the model for one call.

In the chat buffer, `#buffer` / `#buffers` / `#diagnostics` pull in editor context,
`/` lists slash commands, `<C-s>` sends, and `?` shows every binding.

### Claude Code — the full agent (`<leader>i`)

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ic` | n | Toggle Claude |
| `<leader>if` | n | Focus the Claude split |
| `<leader>iC` | n | `--continue` (resume last session) |
| `<leader>ir` | n | `--resume` (pick a past session) |
| `<leader>im` | n | Pick the model |
| `<leader>ib` | n | Add the current buffer to Claude's context |
| `<leader>is` | v | Send the selection to Claude |
| `<leader>iy` | n | Accept Claude's proposed diff |
| `<leader>in` | n | Reject Claude's proposed diff |
| `<leader>iq` | n | Close all pending diffs |

Unlike the old terminal-wrapper plugin, this speaks the same WebSocket IDE protocol
as the VS Code extension. Claude tracks your active buffer and selection on its own,
and its edits open as **real Neovim diff windows** you can edit before accepting
(`:w` accepts, `:q` rejects, or use the maps above).

### DAP (debugger)

| Key | Action |
| --- | --- |
| `<F5>` | Continue |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>b` | Toggle breakpoint |
| `<leader>B` | Conditional breakpoint |
| `<leader>dr` | Open REPL |

### Misc

| Key | Action |
| --- | --- |
| `<leader>u` | Toggle undotree |
| `<leader>mp` | Toggle markdown browser preview |
| `<leader>;` | Pick from dropbar breadcrumb |
| `<leader>t` | Open terminal |
| `<leader>x` | Strip carriage returns (`%s/\r//`) |
| `Q` | Disabled |

Press `<leader>` and pause — **which-key** will show a popup with everything bound under each prefix.

---

## Plugin Reference

### UI / look-and-feel

- **catppuccin** — colorscheme (mocha flavor, transparent background)
- **nvim-transparent** — kill window backgrounds
- **lualine** — statusline; the `diff` component is custom and shows the **whole branch's** added/removed vs `origin/HEAD`
- **bufferline** — slanted tab strip across the top, set to `mode = 'tabs'` so it tracks the vim tabs you navigate with `<C-l>`/`<C-h>`
- **dropbar** — VS Code-style breadcrumbs in the winbar
- **alpha-nvim** — start screen when you run `nvim` with no args
- **indent-blankline** — vertical indent guides
- **which-key** — popup of available leader maps
- **noice + nvim-notify + nui** — modern cmdline / message overlay
- **lsp-colors** — diagnostic highlight groups
- **vim-devicons / nvim-web-devicons** — file icons

### Editing

- **NERDTree** + git status + syntax highlights
- **Comment.nvim** — `gcc` / `gc{motion}` to toggle comments
- **editorconfig** — respect `.editorconfig` files
- **undotree** — visualize undo history
- **ctrlsf** — multi-file find & replace
- **nvim-toggle-terminal** — toggleable terminal split
- **neoformat** — generic formatter command (`:Neoformat`)
- **harpoon** — pin a few files for fast jumping
- **refactoring.nvim** — extract function / variable refactors
- **trouble.nvim** — diagnostic / symbol panels

### Telescope

- **telescope.nvim** + **telescope-fzf-native** (compiled `make` extension) + **plenary**

### Treesitter

- **nvim-treesitter** (main branch — the new API, not the archived master) — parsers and highlighting are wired up in `after/plugin/treesitter.lua`. Highlighting is enabled via a `FileType` autocmd that calls `vim.treesitter.start()`.

### LSP / completion / formatting

- **nvim-lspconfig** + **mason** + **mason-lspconfig** — server install + configuration
- **schemastore.nvim** — JSON schemas for `jsonls`
- **typescript-tools.nvim** — better TS/JS than the default `ts_ls`
- **nvim-cmp** + sources (`buffer`, `path`, `nvim-lsp`, `nvim-lua`, `luasnip`)
- **LuaSnip** + **friendly-snippets**
- **conform.nvim** — format-on-save (prettier, stylua, jq)

### Git

- **vim-fugitive** — the canonical `:Git` interface
- **gitsigns.nvim** — gutter signs, hunks, current-line blame
- **git-conflict.nvim** — conflict markers and resolver

### AI

Three layers, deliberately separate, configured together in `lua/plugins/ai.lua`:

- **zbirenbaum/copilot.lua** — ghost-text completion as you type. Replaces the old
  `copilot.vim`; it's Lua, integrates with nvim-cmp, and exposes the NES API.
- **copilotlsp-nvim/copilot-lsp** — Copilot **Next Edit Suggestions**. Predicts the
  next edit implied by your last one and lets you `<Tab>` to it.
- **olimorris/codecompanion.nvim** — inline edits and the chat buffer. Pinned to
  `^19.0.0`.
- **coder/claudecode.nvim** — the agent, over the real IDE protocol. Replaces
  `greggh/claude-code.nvim`, which only ran `claude` in a terminal split and had no
  awareness of the editor.
- **folke/snacks.nvim** — window primitives that `claudecode.nvim` depends on.

**Which model serves which layer, and why:**

| Layer | Adapter | Backed by |
| --- | --- | --- |
| Completion + NES | Copilot LSP | Copilot subscription |
| Inline edit / cmd | `copilot` (HTTP) | Copilot subscription |
| Chat buffer | `claude_code` (ACP) | Claude subscription |
| Agent | `claude` CLI | Claude subscription |

CodeCompanion's inline interaction **only accepts HTTP adapters** — it bails with
*"Only HTTP adapters are supported for inline interactions"* if given an ACP one. So
inline edits go through the Copilot adapter, which is already authenticated on this
machine and has lower latency anyway for single-shot edits. Chat, where agent
capabilities and project `.claude/` skills actually matter, runs Claude over ACP.

To move inline onto Claude instead, add an API key and set
`interactions.inline.adapter = "anthropic"` — the ACP adapter cannot fill that slot.

### Markdown

- **iamcco/markdown-preview.nvim** — browser-served live preview with mermaid support
- **MeanderingProgrammer/render-markdown.nvim** — in-editor table / heading / code-block rendering

### DAP

- **nvim-dap** + **nvim-dap-ui** + **nvim-nio** + **telescope-dap.nvim**

### Language-specific

- **yats.vim** — TypeScript syntax
- **vim-go** — Go commands and syntax. The LSP side is disabled (`g:go_gopls_enabled = 0`) since `gopls` runs through `nvim-lspconfig`

---

## Customization Tips

### Change the catppuccin flavor

In `after/plugin/colors.lua`, change `flavour = "mocha"` to one of:
- `"latte"` (light)
- `"frappe"` (warm dark)
- `"macchiato"` (mid dark)
- `"mocha"` (high-contrast dark)

Then update `after/plugin/lualine.lua` — `theme = 'catppuccin-mocha'` to match.

### Disable a plugin temporarily

Set `enabled = false` on its spec in `lua/plugins/`, then `:Lazy clean`. Managing
plugins day to day is `:Lazy` — `I` installs, `U` updates, `X` cleans, `S` syncs.

### Update plugins

`:Lazy update`. Revisions are pinned in `lazy-lock.json`, which is committed, so
`:Lazy restore` rolls the whole plugin set back to a known-good state.

### Add a language

1. Add the LSP name to `after/plugin/mason.lua` `ensure_installed`.
2. Add a `vim.lsp.config('name', { on_attach = on_attach })` block in `after/plugin/lsp.lua`.
3. Add the treesitter parser name to the list in `after/plugin/treesitter.lua`.

---

## Troubleshooting

### Deprecation warnings

`git-conflict.nvim` calls `vim.highlight` and the old `vim.validate{<table>}` form. The upstream plugin hasn't been updated in 17+ months. These are warnings, not errors — they only become errors in Neovim 1.0 / 2.0.

### Treesitter error: `attempt to call method 'range' (a nil value)`

You're on the old archived `master` branch of `nvim-treesitter`. The config uses `main`. Run `:Lazy sync` to fix.

### Telescope error: `attempt to call field 'ft_to_lang'`

Telescope 0.1.6 referenced an old `nvim-treesitter` API. The config now tracks telescope's `master` branch which uses the built-in `vim.treesitter.language.get_lang()`.

### lazy.nvim fails on a divergent local commit

Upstream may have rebased / force-pushed. Inside the plugin's directory under
`~/.local/share/nvim/lazy/`:

```sh
git reset --hard origin/HEAD
```

This is safe as long as you haven't made local edits to the plugin.

### Leftover packer plugins

The migration to lazy.nvim moved the old tree aside to
`~/.local/share/nvim/site/pack/packer.bak-<timestamp>/`. Neovim auto-loads anything
under `site/pack/*/start/`, so if that directory is restored you get **two copies of
every plugin** — including the retired `copilot.vim`, which will fight `copilot.lua`
over ghost text. Delete the backup once you're satisfied the new setup works:

```sh
rm -rf ~/.local/share/nvim/site/pack/packer.bak-*
```

### LSP server doesn't attach

Mason needs to have installed it. Run `:Mason`, find the server, press `i`. Alternatively, `:checkhealth lsp` to diagnose.

### Claude Code key (`<leader>ic`) does nothing

Make sure the `claude` CLI is on your `$PATH` (`which claude`). The plugin shells out
to it. `:ClaudeCodeStatus` reports whether the WebSocket server is up and whether
Claude has actually connected to it.

### Chat buffer fails to start

The chat adapter spawns `claude-agent-acp`, which is a **separate** binary from the
`claude` CLI:

```sh
command -v claude-agent-acp || npm install -g @agentclientprotocol/claude-agent-acp
```

If it's installed but still not found, note that a global `npm -g` install is tied to
the active Node version — switching nvm versions hides it. Either reinstall under the
new version, or point the adapter at `npx` in `lua/plugins/ai.lua`:

```lua
adapters = {
  acp = {
    extend = {
      claude_code = {
        commands = { default = { "npx", "-y", "@agentclientprotocol/claude-agent-acp" } },
      },
    },
  },
},
```

If it starts but every request fails to authenticate, `CLAUDE_CODE_OAUTH_TOKEN` is
missing from the environment. Run `claude setup-token` and export it.

### Inline edit errors with "Only HTTP adapters are supported"

You've set `interactions.inline.adapter` to an ACP adapter such as `claude_code`.
Inline only works over HTTP — use `copilot` or `anthropic`. See the AI section above.

### Copilot suggestions never appear

`:Copilot status`. If unauthenticated, run `:Copilot auth`. If the old `copilot.vim`
is still on the runtimepath (see *Leftover packer plugins*), the two plugins will
compete and neither behaves correctly.
