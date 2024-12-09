# NeoVIM Configuration

## Requirements
- GCC
- [BurtSushi/ripgrep](https://github.com/BurntSushi/ripgrep)
- [Packer](https://github.com/wbthomason/packer.nvim)

## Windows
GCC compiler is required for Treesitter. Use [Scoop](https://scoop.sh) to install GCC: `scoop install gcc`

## LSP
Ensures the following are installed and will display errors if the languages
are not installed on the current machine.
- Golang
- TypeScript
- Rust

## Debugger (DAP)
To configure DAP for Rust/C++ install [Codelldb](https://github.com/vadimcn/codelldb/releases) and set the CODELLDB_PATH
environment variable to that path of codelldb.
