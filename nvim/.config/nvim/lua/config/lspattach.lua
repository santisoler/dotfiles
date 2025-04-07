-- Customize the LspAttach autocmd
-- ===============================

-- Nvim ships with a builtin LspAttach autocmd that has some default
-- keybindings that are set when an Lsp is attached. We can override and
-- configure some more keybindings and configs.

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
     local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  end,
})
