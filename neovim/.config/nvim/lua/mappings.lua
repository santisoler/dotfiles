-- Define custom mappings
-- ----------------------

-- Complete with Tab
-- (and navigate between completions with Tab and Shift-Tab)
vim.keymap.set('i', '<Tab>', function()
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    else
        return "<C-x><C-o>"
    end
end, { expr = true })

vim.keymap.set('i', '<S-Tab>', function()
    if vim.fn.pumvisible() == 1 then
        return "<C-p>"
    end
end, { expr = true })
