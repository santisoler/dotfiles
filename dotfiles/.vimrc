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
Plug 'rakr/vim-one'                    " vim-one colorscheme (from atom)
Plug 'tpope/vim-fugitive'              " git wrapper
Plug 'vim-syntastic/syntastic'         " syntax linter
Plug 'vim-airline/vim-airline'         " airline (bottom bar)
Plug 'vim-airline/vim-airline-themes'  " airline themes
Plug 'tweekmonster/braceless.vim', {'for': ['python']}
Plug 'lervag/vimtex'            " latex plugin
Plug 'airblade/vim-gitgutter'   " git flags in the sign column
Plug 'scrooloose/nerdcommenter' " improved comments
Plug 'scrooloose/nerdtree'      " nerdtree
Plug 'python/black'             " black

if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-jedi'
    Plug 'davidhalter/jedi-vim'
endif

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

" Change tabulations and indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set ignorecase
set smartcase

" Enable undo file
set undofile

" Change updatetime for gitgutter
set updatetime=100

" Configure searches
set incsearch
set showmatch
set hlsearch

" Set an 80 characters column
set formatoptions=qrn1
set wrap             " enable soft wrap
set formatoptions+=t " enable hard wrap
set textwidth=88
set colorcolumn=89

" Prevent dual spaces after period
set nojoinspaces

" Split new windows below
set splitbelow

" Disable folding
set nofoldenable

" Configure Git commits and hub pull-requests
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

" Function to configure the cursorline hightlight
" -----------------------------------------------
function! CursorLine()
    " Highlight Line number
    set cursorline
    hi clear CursorLine
    highlight CursorLineNr gui=bold guifg=#282c34 guibg=#61afef
endfunction


" Define function to toggle between colorschemes and airline themes
" -----------------------------------------------------------------
let g:myTheme=0
let g:myColorSchemes=["onedark","one","default"]
let g:myAirlineThemes=["tomorrow","one","base16_atelierdune"]
let g:termguicolorStatus=["termguicolors","termguicolors","notermguicolors"]
function! ToggleTheme()
    let g:myTheme=g:myTheme+1
    if g:myTheme>=len(g:myColorSchemes)
        let g:myTheme=0
    endif
    if (empty($TMUX))
        if (has("termguicolors"))
            execute "set ".get(g:termguicolorStatus, g:myTheme)
        endif
    endif
    execute "colorscheme ".get(g:myColorSchemes, g:myTheme)
    " Set background light for one theme
    if g:myTheme==1
        set background=light
    endif
    execute "AirlineTheme ".get(g:myAirlineThemes, g:myTheme)
    call CursorLine()
endfunction


" Set default colorscheme
if (empty($TMUX))
    if (has("termguicolors"))
        set termguicolors
    endif
endif

colorscheme onedark
call CursorLine()


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

" Pressing \ss will toggle and untoggle spell checking
map <leader>ss :call ToggleSpell()<cr>
" Add word to dictionary (\sa)
map <leader>sa zg
" Substitution option for marked word (\s?)
map <leader>s? z=
" Use ]s and [s to move down-up marked words

" Map F2 to paste mode so that pasting in the terminal doesn't mess identation
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" Mappings for navigate to the start and the end of the paragraph
map <leader>F {j
map <leader>f }k



" ====================
" Plugin Configuration
" ====================

" nerdcommenter
" -------------
filetype plugin indent on
let g:NERDSpaceDelims = 0

" braceless.vim
" -------------
autocmd FileType python BracelessEnable +indent

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
let g:airline_theme='tomorrow'

" syntastic
" ---------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
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
let g:vimtex_enabled=1
let g:vimtex_compiler_enabled=0
let g:vimtex_complete_enabled=1
let g:vimtex_complete_close_braces=1

" jedi-vim
" --------
if has('nvim')
    " Prevent popup docstring on autocompletion
    autocmd FileType python setlocal completeopt-=preview
endif

" deoplete
" --------
let g:deoplete#enable_at_startup = 1

" NERDTree
" --------
" Open NERDTree with Ctrl-n
map <C-n> :NERDTreeToggle<CR>
