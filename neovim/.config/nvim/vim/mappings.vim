" ==================
" Define keymappings
" ==================

" Navigate between windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move to the next and previous buffer
nmap <leader>n :bnext<CR>
nmap <leader>p :bprevious<CR>
nmap ]b :bnext<CR>
nmap [b :bprevious<CR>

" Remove search highlight
nnoremap <leader><space> :noh<cr>

" Map "+y in order to copy to clipboard
" In order to work, :echo has('clipboard') must return 1
" Try installing vim-gtk or gvim according to you distro
vnoremap <C-c> "+y

" Map <leader>s to find and replace
nnoremap <leader>sed :%s/\<<C-r><C-w>\>//g<Left><Left>

" Yank until end of line (source: ThePrimeagen)
nnoremap Y y$

" Keep searches centered (source: ThePrimeagen)
nnoremap n nzzzv
nnoremap N Nzzzv

" Keep cursor fixed when joining lines (source: ThePrimeagen)
nnoremap J mzJ`z

" Create some keybindings for diagnostics (see :help vim.diagnostic.* for docs)
nmap <leader>e <cmd>lua vim.diagnostic.open_float()<CR>
nmap [d <cmd>lua vim.diagnostic.goto_prev()<CR>
nmap ]d <cmd>lua vim.diagnostic.goto_next()<CR>
nmap <leader>q <cmd>lua vim.diagnostic.setloclist()<CR>
