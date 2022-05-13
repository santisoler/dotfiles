" ===================
" Define autocommands
" ===================

" Custom styles on augroup
augroup custom_style
    autocmd!
    " Change text last column for Python files
    autocmd FileType python setlocal colorcolumn=89
    " Set indentation to 2 characters for html and yml
    autocmd FileType html,htmldjango,yml,yaml setlocal ts=2 sts=2 sw=2 expandtab
    " Configure Git commits
    autocmd Filetype gitcommit setlocal spell textwidth=72
    autocmd Filetype pullrequest setlocal spell textwidth=72
augroup END

" Remove trailing spaces on save
augroup trailing_spaces
    au!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

" Show cursor line only in active window
augroup cursorline_active_window
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END

" Autorun linter on read and write (requires nvim-lint)
augroup linter_auto
    autocmd!
    au BufNewFile,BufEnter,BufWritePost * lua require('lint').try_lint()
augroup END

" Run neoformat after saving some chosen files (requires neoformat)
augroup neoformat
    au!
    autocmd BufWritePre *.py,*.html,*.css,*.less,*.yml Neoformat
augroup END

