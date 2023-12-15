call plug#begin()

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'ryanoasis/vim-devicons'
Plug 'folke/lsp-colors.nvim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'eslint/eslint'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'niklaas/lightline-gitdiff'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'caenrique/nvim-toggle-terminal'
Plug 'kien/ctrlp.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'ruanyl/vim-sort-imports'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'xiyaowong/nvim-transparent'
Plug 'tpope/vim-fugitive'
Plug 'codota/tabnine-nvim', { 'do': './dl_binaries.sh' }
Plug 'HerringtonDarkholme/yats.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'williamboman/mason.nvim'

call plug#end()

source $HOME/.config/nvim/plug-config/lspconfig.lua
source $HOME/.config/nvim/plug-config/cmp.lua

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

set number
set relativenumber

set encoding=UTF-8

set tw=79
set wrap linebreak

filetype plugin indent on

let g:lightline#gitdiff#indicator_added = '⬆️: '
let g:lightline#gitdiff#indicator_deleted = '⬇️: '
let g:lightline#gitdiff#separator = ' '

let g:tokyonight_style = "night"
colorscheme tokyonight
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ],
      \             [ 'gitdiff' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename', 'gitversion' ] ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name',
      \ },
      \ 'component_expand': {
      \   'gitdiff': 'lightline#gitdiff#get',
      \ },
      \ 'component_type': {
      \   'gitdiff': 'middle',
      \ },
      \ 'colorscheme': 'tokyonight',
      \ }

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

nnoremap <silent> <C-z> :ToggleTerminal<Enter>
tnoremap <silent> <C-z> <C-\><C-n>:ToggleTerminal<Enter>

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

let g:import_sort_auto = 1

command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

lua << EOF
require('Comment').setup()
EOF


set tabstop=2 shiftwidth=2 expandtab

map <esc> :noh <CR>

set clipboard=unnamedplus

lua << EOF
require('telescope').setup{ defaults = { file_ignore_patterns = {"node_modules"} } }
EOF

lua << EOF
require('telescope').setup{ file_ignore_patterns = {"node_modules"} }
EOF

lua << EOF
require('tabnine').setup({
  disable_auto_comment=true,
  accept_keymap="<Right>",
  dismiss_keymap = "<C-]>",
  debounce_ms = 300,
  suggestion_color = {gui = "#808080", cterm = 244},
  execlude_filetypes = {"TelescopePrompt"}
})
EOF

let g:transparent_enabled = v:true

map <C-L> :tabn<CR>
map <C-H> :tabp<CR>
map <leader>n :tabnew<CR>
map <leader>c :tabc<cr>
map <leader>r <cmd>CocCommand tsserver.findAllFileReferences<CR>

lua << EOF
vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })
EOF
