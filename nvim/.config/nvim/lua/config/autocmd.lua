-- ===================
-- Define autocommands
-- ===================

-- ------------------------------
-- Remove trailing spaces on save
-- ------------------------------
vim.api.nvim_create_augroup("trailing_spaces", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = "trailing_spaces",
	pattern = { "*" },
	callback = trim_trailing_whitespaces,
})

-- ---------------------------------
-- Custom styles for some file types
-- ---------------------------------
vim.api.nvim_create_augroup("custom_style", { clear = true })
-- Change text last column for Python files
vim.api.nvim_create_autocmd("FileType", {
	group = "custom_style",
	pattern = { "python" },
	command = "setlocal colorcolumn=89 textwidth=88",
})
-- Change text last column for Rust files
vim.api.nvim_create_autocmd("FileType", {
	group = "custom_style",
	pattern = { "rust" },
	command = "setlocal colorcolumn=100 textwidth=99",
})
-- Set indentation to 2 characters for markdown files
vim.api.nvim_create_autocmd("FileType", {
	group = "custom_style",
	pattern = { "markdown" },
	command = "setlocal ts=2 sts=2 sw=2 expandtab",
})
-- Configure Git commits
vim.api.nvim_create_autocmd("FileType", {
	group = "custom_style",
	pattern = { "gitcommit", "pullrequest" },
	command = "setlocal spell textwidth=72",
})

-- ----------------------------------------------
-- Enable spellcheck by default on some filetypes
-- ----------------------------------------------
vim.api.nvim_create_augroup("spelling", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "spelling",
	pattern = { "html", "markdown", "python", "tex", "rst", "typst" },
	command = "setlocal spell | set spelllang=en",
})
