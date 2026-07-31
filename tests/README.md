# Config smoke tests

`verify.lua` asserts the config actually loads and is wired the way the README claims:
modules resolve, commands register, AI adapters point at the right backends, keymaps
exist, and the things the lazy.nvim migration could have silently broken still hold
(leader is backslash, harpoon still owns `\a`, `copilot.vim` is gone, no packer tree
on the runtimepath).

```sh
nvim --headless -c "luafile tests/verify.lua" -c qa; echo "exit: $?"
```

Non-zero exit means at least one check failed; each failure prints the offending value.

Run this after touching `lua/plugins/`, `lua/achill113/lazy.lua`, or the cmp mapping in
`after/plugin/lsp.lua`.

The `nerdtree` section builds a throwaway git repo and opens the tree in it, because both
ways NERDTree's decorations broke under lazy are invisible until something renders: the
`runtime! nerdtree_plugin/**` load order, and vim-devicons' bracket conceal being cleared
by the syntaxset `FileType` autocmd. It is the slowest section — the git flags come from an
async `git status` job, so it polls for up to ten seconds.

Two things it deliberately does **not** cover, because both need credentials and a
network round trip:

- that the Copilot adapter can complete a request — exercise it with `\kk` on a real buffer
- that the chat buffer can authenticate — needs `CLAUDE_CODE_OAUTH_TOKEN`; check with `\kc`

Note that Copilot's Next Edit Suggestion keymap is **buffer-local** and only attaches
once the Copilot LSP client connects, so the suite asserts the config survived
`validate()` and that `set_keymap` binds `<Tab>` — not that a global `<Tab>` map exists.
