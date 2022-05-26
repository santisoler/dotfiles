" ============================
" General Neovim Configuration
" ============================

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

" Configure format options
" Find more about format options with :h fo-table
" Neovim defaults to "tcqj":
"     - t: auto-wrap text using textwidth
"     - c: auto-wrap comments inserting comment leader automatically
"     - q: format comments with "gq"
"     - j: remove comment leader when joining lines
set formatoptions=tcqj
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
