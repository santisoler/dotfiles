-- Configure nvim-tree
require'nvim-tree'.setup {
    filters = {dotfiles = true},
    git = {ignore = false},
}

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>")
