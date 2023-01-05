" =========================
" General Vim Configuration
" =========================

" Some Neovim defaults
set nocompatible
set modelines=0
set autoread

" Map leader to spacebar
let mapleader = " "

" Enable syntax
syntax on

" Show line numbers
set number
" set relativenumber

" Enable mouse interaction inside vim (only on Visual and Normal mode)
set mouse=vn

" Change configuration for cases
set ignorecase
set smartcase

" Enable undo file
set undofile

" Change updatetime for gitgutter
set updatetime=300

" Configure searches
set incsearch
set showmatch
set hlsearch

" Set hidden (keeps buffers in the background)
set hidden

" Set text width to 80 characters
set textwidth=79

" Configure indentations
set autoindent
set expandtab
set tabstop=4 softtabstop=4 shiftwidth=4

" Text wrap
set wrap
set breakindent
set textwidth=79

" Configure format options
" Find more about format options with :h fo-table
"   - t: auto-wrap text using textwidth
"   - c: auto-wrap comments inserting comment leader automatically
"   - q: format comments with "gq"
"   - j: remove comment leader when joining lines
set formatoptions=tcqj " Neovim defaults
set formatoptions+=r   " insert comment char after hitting enter in Insert mode
set formatoptions-=o   " don't insert comment char on new line in Normal mode
set formatoptions+=n   " recognize numbered lists when formatting text
set formatoptions+=1   " don't break a like after a one-letter word

" Enable breakindent (soft-wrapped lines will follow indent)
set breakindent

" Prevent dual spaces after period
set nojoinspaces

" Split new windows below
set splitbelow

" Disable folding
set nofoldenable

" Set number of context lines when scrolling
set scrolloff=10

" Remove trailing spaces on save
augroup trailing_spaces
    au!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END


" ========
" Mappings
" ========

" Move to the next and previous buffer
nmap <leader>n :bnext<CR>
nmap <leader>p :bprevious<CR>
nmap ]b :bnext<CR>
nmap [b :bprevious<CR>

" Delete current buffer
nmap <leader>d :bd<CR>

" Split keyboard shortcuts
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Remove search highlight
nnoremap <leader><space> :noh<cr>

" Map "+y in order to copy to clipboard
" In order to work, :echo has('clipboard') must return 1
" Try installing vim-gtk or gvim according to you distro
vnoremap <C-c> "+y

" Yank until end of line (source: ThePrimeagen)
nnoremap Y y$

" Keep searches centered (source: ThePrimeagen)
nnoremap n nzzzv
nnoremap N Nzzzv

" Keep cursor fixed when joining lines (source: ThePrimeagen)
nnoremap J mzJ`z


" ==================================
" Plugin Installation using vim-plug
" ==================================

" Automatically download and install vim-plug if it's not installed
"
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !wget -p ~/.vim/autoload/
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plugins are downloaded from Github (username/repo)
" Use :PlugInstall to install them
call plug#begin('~/.vim/plugged')

" Git
Plug 'airblade/vim-gitgutter'  " git flags in the sign column
Plug 'tpope/vim-fugitive'      " git wrapper

" Comments
Plug 'tpope/vim-commentary'

call plug#end()

" Configure gitgutter
" -------------------
set signcolumn=yes
highlight SignColumn ctermbg=NONE
highlight GitGutterAdd    ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)
