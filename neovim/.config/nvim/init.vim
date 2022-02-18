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
Plug 'airblade/vim-gitgutter'          " git flags in the sign column
Plug 'tpope/vim-fugitive'              " git wrapper
Plug 'vim-syntastic/syntastic'         " syntax linter
Plug 'scrooloose/nerdcommenter'        " improved comments
Plug 'scrooloose/nerdtree'             " nerdtree
Plug 'Xuyuanp/nerdtree-git-plugin'     " show git icons on nerdtree
Plug 'tpope/vim-surround'              " surround highlighted text
Plug 'lervag/vimtex'                   " latex plugin
Plug 'ap/vim-css-color'                " highlight RGB colors
Plug 'mattn/emmet-vim'                 " for HTML completion
Plug 'sbdchd/neoformat'                " formatter for multiple languages
Plug 'arcticicestudio/nord-vim'        " Nord theme for Neovim
Plug 'vim-airline/vim-airline'         " airline (bottom bar)
Plug 'vim-airline/vim-airline-themes'  " airline themes
Plug 'nvim-telescope/telescope.nvim'   " fuzzy finder
Plug 'nvim-lua/plenary.nvim'           " needed by telescope
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'vimwiki/vimwiki'

" LSP
Plug 'neovim/nvim-lspconfig'           " configurations for built-in LSP client

" LSP autocompletion
" Plug 'hrsh7th/nvim-cmp'                " autocompletion plugin
" Plug 'hrsh7th/cmp-nvim-lsp'            " LSP source for nvim-cmp
" Plug 'hrsh7th/cmp-buffer'              " autocomplete with words from buffer
" Plug 'hrsh7th/cmp-path'                " autocomplete paths
" Plug 'hrsh7th/cmp-cmdline'             " autocompletion for vim's command line
" Plug 'saadparwaiz1/cmp_luasnip'        " Snippets source for nvim-cmp
" Plug 'L3MON4D3/LuaSnip'                " Snippets plugin

call plug#end()


" ============
" Color scheme
" ============
if (empty($TMUX))
    if (has("termguicolors"))
        set termguicolors
    endif
endif

" Set colorscheme
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
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_theme='nord'
" let g:airline#extensions#branch#symbol = '⎇  '
" let g:airline_left_sep = ''
" let g:airline_right_sep = ''

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
" make flake8 compatible with black
let g:syntastic_python_flake8_args="--max-line-length=88 --ignore=W503,E203"
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
" Don't stop when running the first formatter, run all
let g:neoformat_run_all_formatters = 1
" Configure isort and black autoformatters
let g:neoformat_enabled_python = ['isort', 'black']
let g:neoformat_python_isort = {'args': ['--profile black']}

" Run neoformat after saving some chosen files
augroup neoformat
    au!
    autocmd BufWritePre *.py,*.html,*.css,*.less,*.yml Neoformat
augroup END

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

" markdown-preview.nvim
" ---------------------
" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
let g:mkdp_auto_close = 0

" vimwiki
" -------
let g:vimwiki_list = [{
	\ 'path': '~/documents/vimwiki',
	\ 'template_path': '~/documents/vimwiki/templates/',
	\ 'template_default': 'default',
	\ 'syntax': 'markdown',
	\ 'ext': '.md',
	\ 'path_html': '~/documents/vimwiki/site_html/',
	\ 'custom_wiki2html': 'vimwiki_markdown',
	\ 'template_ext': '.tpl'}]
let g:vimwiki_global_ext = 0



" lsp
" ---
" Configure LSP with the default configuration for lsp-config
" Some keybindings are defined inside the lua sources
lua require("lsp-default")

" Create a function that makes it possible to complete with Tab and Shift+Tab
function! InsertTabWrapper()
  if pumvisible()
    return "\<c-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-x>\<c-o>"
  endif
endfunction

inoremap <expr><tab> InsertTabWrapper()
inoremap <expr><s-tab> pumvisible()?"\<c-p>":"\<c-d>"

" ----------------------------------
" These configurations are for lsp + autocompletion (not compatible with the
" previous ones)

" lua require("lsp-cmp")
" nnoremap K <cmd>lua vim.lsp.buf.hover()<cr>
" nnoremap gd <cmd>lua vim.lsp.buf.definition()<cr>
" nnoremap gD <cmd>lua vim.lsp.buf.declaration()<cr>
" nnoremap gi <cmd>lua vim.lsp.buf.implementation()<cr>
" ----------------------------------
