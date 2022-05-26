" ==================================
" Plugin Installation using vim-plug
" ==================================

" Automatically download and install vim-plug if it's not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Plugins are downloaded from Github (username/repo)
call plug#begin('~/.vim/plugged')

    " Nord theme
    Plug 'arcticicestudio/nord-vim'

    " Git
    Plug 'lewis6991/gitsigns.nvim' " git flags in the sign column
    Plug 'tpope/vim-fugitive'      " git wrapper

    " Surrounding characters
    Plug 'tpope/vim-surround'     " surround highlighted text

    " LaTeX
    Plug 'lervag/vimtex'                   " latex plugin

    " Webdev
    Plug 'ap/vim-css-color'                " highlight RGB colors
    Plug 'mattn/emmet-vim'                 " for HTML completion

    " Autoformat files
    Plug 'sbdchd/neoformat'                " formatter for multiple languages

    " Vimwiki and markdown preview
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
    Plug 'vimwiki/vimwiki'

    " Comment.nvim
    Plug 'numToStr/Comment.nvim'

    " nvim-tree
    Plug 'kyazdani42/nvim-tree.lua'

    " lualine.nvim
    Plug 'nvim-lualine/lualine.nvim'

    " bufferline
    Plug 'akinsho/bufferline.nvim'

    " nvim-lint
    Plug 'mfussenegger/nvim-lint'

    " LSP
    Plug 'neovim/nvim-lspconfig'

    " cmp
    Plug 'hrsh7th/nvim-cmp'         " Autocompletion plugin
    Plug 'hrsh7th/cmp-nvim-lsp'     " LSP source for nvim-cmp
    Plug 'saadparwaiz1/cmp_luasnip' " Snippets source for nvim-cmp
    Plug 'hrsh7th/cmp-path'         " complete paths with nvim-cmp
    Plug 'L3MON4D3/LuaSnip'         " Snippets plugin

    " Tree-sitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'lewis6991/spellsitter.nvim'

    " toggle lsp diagnostics
    Plug 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'

call plug#end()



" -----------------
" Configure plugins
" -----------------

" Colorscheme
" -----------
if (empty($TMUX))
    if (has("termguicolors"))
        set termguicolors
    endif
endif

colorscheme nord

" Load plugins configurations from lua files
" ------------------------------------------
lua require("conf.bufferline")
lua require("conf.comment")
lua require("conf.git-signs")
lua require("conf.lspconfig")
lua require("conf.cmp")
lua require("conf.lualine")
lua require("conf.nvim-lint")
lua require("conf.nvim-tree")
lua require("conf.toggle_lsp_diagnostics")
lua require("conf.treesitter")


" lsp
" ---
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


" vimtex
" ------
filetype plugin indent on
let maplocalleader = ","
let g:vimtex_view_method = 'zathura'
let g:tex_flavor = 'latex'
let g:vimtex_compiler_enabled=1
" let g:vimtex_compiler_method = 'tectonic'
let g:vimtex_compiler_latexmk = {'build_dir' : '_output'}
let g:vimtex_compiler_tectonic = {'build_dir' : '_output'}
let g:vimtex_complete_enabled=1
let g:vimtex_complete_close_braces=1


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
