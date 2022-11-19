-- =========================
-- Configure catpuccin theme
-- =========================
require("catppuccin").setup({
    no_italic = false, -- Force no italic
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin-macchiato"
