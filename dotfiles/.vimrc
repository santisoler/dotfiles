" ==================================
" Plugin Installation using vim-plug
" ==================================
" Visit https://github.com/junegunn/vim-plug for more info
" Automatically download and install vim-plug if it's not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Plugins are downloaded from Github (username/repo)
Plug 'joshdick/onedark.vim'            " onedark colorscheme (from atom)
Plug 'tpope/vim-fugitive'              " git wrapper
Plug 'vim-syntastic/syntastic'         " syntax linter
Plug 'vim-airline/vim-airline'         " airline (bottom bar)
Plug 'vim-airline/vim-airline-themes'  " airline themes
Plug 'lervag/vimtex'                   " latex plugin
Plug 'airblade/vim-gitgutter'          " git flags in the sign column
Plug 'scrooloose/nerdcommenter'        " improved comments
Plug 'scrooloose/nerdtree'             " nerdtree
Plug 'Xuyuanp/nerdtree-git-plugin'     " show git icons on nerdtree
Plug 'mattn/emmet-vim'                 " for HTML completion
Plug 'neoclide/coc.nvim', {'branch': 'release'} " smart autocompletion
Plug 'sbdchd/neoformat'                " formatter for multiple languages

call plug#end()


" =====================
" General Configuration
" =====================
set nocompatible
set modelines=0

" Map leader to -
let mapleader = "-"

" Show line numbers
set number

" Enable mouse interaction inside vim (only on Visual and Normal mode)
set mouse=vn

" Set indentation to 4 characters (except for html and yml)
set autoindent tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab

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

" Set text width to 80 characters (88 for Python)
set noai textwidth=79
autocmd FileType python setlocal textwidth=79

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

" Configure Git commits
autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd Filetype pullrequest setlocal spell textwidth=72

" Syntax highlightning
syntax on
autocmd BufNewFile,BufRead *.ipy set filetype=python
autocmd BufNewFile,BufRead *.pyx set filetype=python
autocmd BufNewFile,BufRead SConstruct set filetype=python
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead Snakefile set syntax=snakemake
autocmd BufNewFile,BufRead *.snake set syntax=snakemake

" Remove trailing spaces on save
" To disable this from running on a one-time saving, run:
"   :noautocmd w
autocmd BufWritePre * :%s/\s\+$//e


" ============
" Color scheme
" ============
if (empty($TMUX))
    if (has("termguicolors"))
        set termguicolors
    endif
endif

" Change background color to match Matcha Sea theme
" (must be before 'colorscheme onedark')
let g:onedark_color_overrides = {
\ "black": {"gui": "#141A1B", "cterm": "235", "cterm16": "0" },
\}

" Set colorscheme
colorscheme onedark

" Highlight CursorLine depending on mode (as airline onedark theme)
set cursorline
hi clear CursorLine
highlight CursorLineNr gui=bold guifg=#282c34 guibg=#98C379


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
" autocmd BufNewFile,BufRead *.ipy,*.py,*.md,*.tex,*.rst,*.c,*.h,Makefile setlocal spell
autocmd BufNewFile,BufRead *.md,*.tex,*.rst setlocal spell

" ========
" Mappings
" ========

" Move to the next and previous buffer
" Please check if airline has <let g:airline#extensions#tabline#enabled = 1>
nmap <leader>bn :bnext!<CR>
nmap <leader>bp :bprevious!<CR>

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


" ====================
" Plugin Configuration
" ====================

" nerdcommenter
" -------------
filetype plugin indent on
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

" vim-airline
" -----------
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#symbol = '⎇  '
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='onedark'

" syntastic
" ---------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_tex_checkers = ['lacheck', 'text/language_check']
let g:syntastic_rst_checkers = ['text/language_check']
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args="--max-line-length=88"
let g:syntastic_tex_lacheck_quiet_messages = {'regex': '\Vpossible unwanted space at'}
map <leader>sy :call SyntasticToggleMode()<cr>

" gitgutter
" ---------
" Existing mappings:
"   <Leader>hu : Undo hunk
nmap <Leader>hv <Plug>(GitGutterPreviewHunk)
nmap <Leader>hn <Plug>(GitGutterNextHunk)
nmap <Leader>hp <Plug>(GitGutterPrevHunk)
" Stage and reset hunks
nmap <Leader>ha <Plug>(GitGutterStageHunk)
nmap <Leader>hr <Plug>(GitGutterUndoHunk)

" vimtex
" ------
let g:tex_flavor = 'latex'
let g:vimtex_enabled=1
let g:vimtex_compiler_enabled=0
let g:vimtex_complete_enabled=1
let g:vimtex_complete_close_braces=1

" NERDTree
" --------
" Open NERDTree with Ctrl-n
map <C-n> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

" Emmet
" -----
let g:user_emmet_leader_key='<C-Z>'

" neoformat
" ---------
let g:neoformat_enabled_python = ['black']
" Run black after saving Python files
autocmd BufWritePre *.py Neoformat
" Run prettier after saving html and css files
autocmd BufWritePre *.html,*.css,*.less Neoformat


" -------------------------------------------------

" coc-nvim
" --------
map <leader>r <Plug>(coc-rename)

" Use Ctrl+K to show documentation in preview window.
nnoremap <silent> <C-K> :call <SID>show_documentation()<CR>

function! s:show_documentation()
    call CocAction('doHover')
endfunction
