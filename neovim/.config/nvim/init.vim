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

-- Define function for getting conda environment
local function getCondaEnv()
    local conda_env = os.getenv("CONDA_DEFAULT_ENV")
    if conda_env == "" then
        return ""
    end
    return " " .. conda_env
end

require('lualine').setup {
  options = {
    section_separators = '',
    component_separators = ''
  },
  sections = {
    lualine_b = {'branch', 'diff', getCondaEnv, 'diagnostics'},
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
  sh = {'shellcheck'},
}
EOF

" Autorun linter on read and write
augroup linter_auto
    autocmd!
    au BufReadPost * lua require('lint').try_lint()
    au BufWritePost * lua require('lint').try_lint()
augroup END

" gitsigns
" --------
lua << EOF
require('gitsigns').setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
EOF

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
lua << EOF
require'nvim-tree'.setup {
    filters = {dotfiles = true},
    git = {ignore = false},
}
EOF
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
