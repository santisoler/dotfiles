" =========================
" General Vim Configuration
" =========================
set nocompatible  " neovim is always nocompatible (this line is only for vim)
set modelines=0

" Map leader to spacebar
let mapleader = " "

" Show line numbers
set number
set relativenumber

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

" Add signcolumn
set signcolumn=yes

" Set hidden (keeps buffers in the background)
set hidden

" Set text width to 80 characters
set noai textwidth=79
set colorcolumn=80

" Custom styles on augroup
augroup custom_style
    autocmd!
    " Change text last column for Python files
    autocmd FileType python setlocal colorcolumn=89
    " Set indentation to 4 characters (except for html and yml)
    set autoindent tabstop=4 softtabstop=4 shiftwidth=4 expandtab
    autocmd FileType html,yml,yaml setlocal ts=2 sts=2 sw=2 expandtab
    " Configure Git commits
    autocmd Filetype gitcommit setlocal spell textwidth=72
    autocmd Filetype pullrequest setlocal spell textwidth=72
augroup END

" Enable soft and hard wrapping
set formatoptions=qrn1
set wrap             " enable soft wrap
set formatoptions+=t " enable hard wrap

" Enable breakindent (soft-wrapped lines will follow indent)
set breakindent

" Prevent dual spaces after period
set nojoinspaces

" Split new windows below
set splitbelow

" Disable folding
set nofoldenable

" Highlight cursorline
set cursorline

" Set number of context lines when scrolling
set scrolloff=10

" Syntax highlightning
syntax on
augroup syntax
    au!
    autocmd BufNewFile,BufRead *.ipy set filetype=python
    autocmd BufNewFile,BufRead *.pyx set filetype=python
    autocmd BufNewFile,BufRead SConstruct set filetype=python
    autocmd BufNewFile,BufRead *.md set filetype=markdown
    autocmd BufNewFile,BufRead Snakefile set syntax=snakemake
    autocmd BufNewFile,BufRead *.snake set syntax=snakemake
augroup END

" Remove trailing spaces on save
augroup trailing_spaces
    au!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END


" ===========
" Spell Check
" ===========

" Function to rotate the spell language that is used
let b:myLang=0
let g:myLangList=["nospell","es","en_us","en_gb"]
function! ToggleSpell()
    if !exists( "b:myLang" )
        let b:myLang=0
    endif
    let b:myLang=b:myLang+1
    if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
    if b:myLang==0
        setlocal nospell
    else
        execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
    endif
    echo "spell checking language:" g:myLangList[b:myLang]
endfunction

" Spelling always on for some files
augroup spelling
    au!
    autocmd BufNewFile,BufRead *.md,*.tex,*.rst,*.py setlocal spell
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

" Pressing <leader>ss will toggle and untoggle spell checking
map <leader>ss :call ToggleSpell()<cr>
" Add word to dictionary (<leader>sa)
map <leader>sa zg
" Substitution option for marked word (<leader>s?)
map <leader>s? z=
" Use ]s and [s to move down-up marked words

" Map F2 to paste mode so that pasting in the terminal doesn't mess identation
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" Map <leader>s to find and replace
nnoremap <leader>sed :%s/\<<C-r><C-w>\>//g<Left><Left>

" Mappings for navigate to the start and the end of the paragraph
map <leader>F {j
map <leader>f }k

" Yank until end of line (source: ThePrimeagen)
nnoremap Y y$

" Keep searches centered (source: ThePrimeagen)
nnoremap n nzzzv
nnoremap N Nzzzv

" Keep cursor fixed when joining lines (source: ThePrimeagen)
nnoremap J mzJ`z

" Move text up and down without ddp (source: ThePrimeagen)
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==
vnoremap <leader>k :m '<-2<CR>gv=gv
vnoremap <leader>j :m '>+1<CR>gv=gv


" -------------------------------------
" Load template when creating new files
" -------------------------------------
augroup templates
    au!
    if !empty(glob("~/templates/README.md"))
        autocmd BufNewFile README.md 0r ~/templates/README.md
    endif
    if !empty(glob("~/templates/letter.tex"))
        autocmd BufNewFile letter.tex 0r ~/templates/letter.tex
    endif
    if !empty(glob("~/templates/environment.yml"))
        autocmd BufNewFile environment.yml 0r ~/templates/environment.yml
    endif
augroup END
