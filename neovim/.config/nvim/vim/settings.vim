" ===============---==========
" General Neovim Configuration
" ============---=============

" Map leader to spacebar
let mapleader = " "

" Configure Python host
let g:python3_host_prog = '/usr/bin/python'

" Configure indentations
set expandtab
set tabstop=4 softtabstop=4 shiftwidth=4

" Text wrap
set wrap
set breakindent
set textwidth=79
set formatoptions=t  " auto-wrap text using textwidth
set formatoptions+=q  " format comments with `gq`
set formatoptions+=r  " insert comment char after hitting enter in Insert mode
set formatoptions-=o  " don't insert comment char on new line in Normal mode
set formatoptions+=n  " recognize numbered lists when formatting text
set formatoptions+=1  " don't break a like after a one-letter word

" Change configuration for cases
set ignorecase
set smartcase

" Add colorcolumn
set colorcolumn=80

" Show relative line numbers
set number
set relativenumber

" Add signcolumn
set signcolumn=yes

" Highlight cursorline
set cursorline

" Split new windows below
set splitbelow

" Disable folding
set nofoldenable

" Enable mouse interaction inside vim (only on Visual and Normal mode)
set mouse=vn

" Enable undo file
set undofile

" Set number of context lines when scrolling
set scrolloff=10

" Enable spellcheck by default
set spell
set spelllang=es,en
