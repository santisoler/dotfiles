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

