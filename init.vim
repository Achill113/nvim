call plug#begin()

Plug 'ryanoasis/vim-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'
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

call plug#end()

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
     \ pumvisible() ? "\<C-n>" :
     \ <SID>check_back_space() ? "\<Tab>" :
     \ coc#refresh()

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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

command! -nargs=0 Prettier :CocCommand prettier.formatFile

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

nnoremap <C-a> <Plug>(coc-codeaction-cursor)

set clipboard=unnamedplus

lua << EOF
require('telescope').setup{ defaults = { file_ignore_patterns = {"node_modules"} } }
EOF

lua << EOF
require('telescope').setup{ file_ignore_patterns = {"node_modules"} }
EOF

let g:transparent_enabled = v:true

map <C-L> :tabn<CR>
map <C-H> :tabp<CR>
map <leader>n :tabnew<CR>
map <leader>c :tabc<cr>
map <leader>r <cmd>CocCommand tsserver.findAllFileReferences<CR>
