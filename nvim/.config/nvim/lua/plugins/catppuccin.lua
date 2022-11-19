-- =========================
-- Configure catpuccin theme
-- =========================
require("catppuccin").setup({
    no_italic = true, -- Force no italic
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin-macchiato"
