-- Define custom mappings
-- ----------------------

-- Complete with Tab
-- (and navigate between completions with Tab and Shift-Tab)
vim.keymap.set('i', '<Tab>', function()
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    end
    -- Get current column
    col = vim.fn.col('.') - 1
    -- Get current char
    curr_char = vim.fn.getline('.'):sub(col, col+1)
    -- Check if line is empty or cursor is standing on a space character
    if col == 0 or curr_char == " " then
        return "<Tab>"
    else
        return "<C-x><C-o>"
    end
end, { expr = true })

vim.keymap.set('i', '<S-Tab>', function()
    if vim.fn.pumvisible() == 1 then
        return "<C-p>"
    end
end, { expr = true })
