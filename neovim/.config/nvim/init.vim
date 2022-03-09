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


" Nord theme
Plug 'arcticicestudio/nord-vim'

" Git
Plug 'airblade/vim-gitgutter' " git flags in the sign column
Plug 'tpope/vim-fugitive'     " git wrapper

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

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" nvim-tree
Plug 'kyazdani42/nvim-tree.lua'

" lualine.nvim
Plug 'nvim-lualine/lualine.nvim'

" bufferline
Plug 'akinsho/bufferline.nvim'

" nvim-lint
" Plug 'mfussenegger/nvim-lint'
Plug 'santisoler/nvim-lint', {'branch': 'lacheck'}

" LSP
Plug 'neovim/nvim-lspconfig'

" toggle lsp diagnostics
Plug 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'

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

" Toggle lsp diagnostics
" ----------------------
lua <<EOF
require'toggle_lsp_diagnostics'.init()
EOF

nmap <leader>tlu <Plug>(toggle-lsp-diag-underline)
nmap <leader>tls <Plug>(toggle-lsp-diag-signs)
nmap <leader>tlv <Plug>(toggle-lsp-diag-vtext)
nmap <leader>tlp <Plug>(toggle-lsp-diag-update_in_insert)

nmap <leader>tld  <Plug>(toggle-lsp-diag)
nmap <leader>tldd <Plug>(toggle-lsp-diag-default)
nmap <leader>tldo <Plug>(toggle-lsp-diag-off)
nmap <leader>tldf <Plug>(toggle-lsp-diag-on)

" Comment.nvim
" ------------
lua require('Comment').setup()

" lualine
" -------
lua << EOF
-- Define function for counting words in document
local function getWords()
  if vim.bo.filetype == "tex" or vim.bo.filetype == "txt" or vim.bo.filetype == "markdown" then
    if vim.fn.wordcount().visual_words == 1 then
      return tostring(vim.fn.wordcount().visual_words) .. " word"
    elseif not (vim.fn.wordcount().visual_words == nil) then
      return tostring(vim.fn.wordcount().visual_words) .. " words"
    else
      return tostring(vim.fn.wordcount().words) .. " words"
    end
  else
    return ""
  end
end

require('lualine').setup {
  options = {
    section_separators = '',
    component_separators = ''
  },
  sections = {
    lualine_y = {getWords, 'progress'},
  },
}
EOF

" bufferline
" ----------
lua << EOF
require('bufferline').setup{
  options = {
    offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "center"}},
    separator_style = "thin",
    always_show_bufferline = false,
    show_close_icon = false,
  }
}
EOF

" nvim-lint
" ---------
lua << EOF
require('lint').linters_by_ft = {
  python = {'flake8',},
  tex = {'chktex', 'lacheck'},
}
EOF

" Autorun linter on read and write
augroup linter_auto
    autocmd!
    au BufReadPost <buffer> lua require('lint').try_lint()
    au BufWritePost <buffer> lua require('lint').try_lint()
augroup END

" gitgutter
" ---------
nmap <leader>hv <Plug>(GitGutterPreviewHunk)
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
" Stage and reset hunks
nmap <leader>ha <Plug>(GitGutterStageHunk)
nmap <leader>hr <Plug>(GitGutterUndoHunk)

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

" nvim-tree
" ---------
lua require'nvim-tree'.setup()
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>

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

" Create some keybindings (see :help vim.diagnostic.* for docs)
nmap <leader>e <cmd>lua vim.diagnostic.open_float()<CR>
nmap [d <cmd>lua vim.diagnostic.goto_prev()<CR>
nmap ]d <cmd>lua vim.diagnostic.goto_next()<CR>
nmap <leader>q <cmd>lua vim.diagnostic.setloclist()<CR>

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
