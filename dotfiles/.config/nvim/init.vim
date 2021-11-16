" Source regular Vim configuration
" ================================
source ~/.vimrc


" Configure Python host and path
" ==============================
let g:python3_host_prog = '/usr/bin/python'
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath


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
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
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
Plug 'tpope/vim-surround'              " surround highlighted text
Plug 'ap/vim-css-color'
Plug 'nvim-lua/plenary.nvim'           " needed by telescope
Plug 'nvim-telescope/telescope.nvim'   " fuzzy finder
Plug 'arcticicestudio/nord-vim'

call plug#end()


" ============
" Color scheme
" ============
if (empty($TMUX))
    if (has("termguicolors"))
        set termguicolors
    endif
endif

" let g:onedark_color_overrides = {
" \ "white": {"gui": "#dcdfe4", "cterm": "235", "cterm16": "0" },
" \}

" Set colorscheme
" colorscheme onedark
colorscheme nord


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
let g:airline_powerline_fonts = 1
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline#extensions#syntastic#enabled = 1
" let g:airline#extensions#branch#symbol = '⎇  '
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
" let g:airline_theme='onedark'
let g:airline_theme='nord'

" syntastic
" ---------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_tex_checkers = [''] " disable syntastic in latex file
" let g:syntastic_tex_checkers = ['lacheck', 'text/language_check']
let g:syntastic_rst_checkers = ['text/language_check']
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args="--max-line-length=88"
let g:syntastic_tex_lacheck_quiet_messages = {'regex': '\Vpossible unwanted space at'}
map <leader>sy :call SyntasticToggleMode()<cr>

" gitgutter
" ---------
" Existing mappings:
"   <Leader>hu : Undo hunk
nmap <leader>hv <Plug>(GitGutterPreviewHunk)
nmap <leader>hn <Plug>(GitGutterNextHunk)
nmap <leader>hp <Plug>(GitGutterPrevHunk)
" Stage and reset hunks
nmap <leader>ha <Plug>(GitGutterStageHunk)
nmap <leader>hr <Plug>(GitGutterUndoHunk)

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
" Run neoformat after saving some chosen files
autocmd BufWritePre *.py,*.html,*.css,*.less,*.yml Neoformat

" telescope
" ---------
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" coc-nvim
" --------

" Install extensions
let g:coc_global_extensions = [
            \ 'coc-pyright',
            \ 'coc-highlight',
            \ 'coc-html',
            \ 'coc-css',
            \ 'coc-eslint',
            \ 'coc-texlab',
            \ 'coc-emoji',
            \ ]

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Use Ctrl+K to show documentation in preview window.
nnoremap <silent> <S-Tab> :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Use the current conda environment
if $CONDA_PREFIX == ""
  let s:current_python_path=$CONDA_PYTHON_EXE
else
  let s:current_python_path=$CONDA_PREFIX.'/bin/python'
endif
" call coc#config('python', {'pythonPath': s:current_python_path})
