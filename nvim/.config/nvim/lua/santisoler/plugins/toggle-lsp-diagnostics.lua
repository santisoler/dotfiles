-- Configure toggle_lsp_diagnostics
require('toggle_lsp_diagnostics').init(
  vim.diagnostic.config()  -- presever current diagnostic configuration
)


-- Configure some keybindings
vim.keymap.set("n", "<leader>tlu", "<Plug>(toggle-lsp-diag-underline)")
vim.keymap.set("n", "<leader>tls", "<Plug>(toggle-lsp-diag-signs)")
vim.keymap.set("n", "<leader>tlv", "<Plug>(toggle-lsp-diag-vtext)")
vim.keymap.set("n", "<leader>tlp", "<Plug>(toggle-lsp-diag-update_in_insert)")

vim.keymap.set("n", "<leader>td",  "<Plug>(toggle-lsp-diag)")
vim.keymap.set("n", "<leader>tldd", "<Plug>(toggle-lsp-diag-default)")
vim.keymap.set("n", "<leader>tldo", "<Plug>(toggle-lsp-diag-off)")
vim.keymap.set("n", "<leader>tldf", "<Plug>(toggle-lsp-diag-on)")
