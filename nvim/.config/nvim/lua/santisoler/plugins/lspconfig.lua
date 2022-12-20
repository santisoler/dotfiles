-- ====================
-- Configure lsp-config
-- ====================

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Disable lsp formatexpr (use the internal one)
  vim.opt.formatexpr = ""

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workleader_folders()))
  end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
end


-- ==========================
-- Configure language servers
-- ==========================

-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- C language server
require('lspconfig')["ccls"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Bash language server
require('lspconfig')["bashls"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Pylsp
require('lspconfig')["pylsp"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    -- configure plugins in pylsp
    pylsp = {
      plugins = {
        pyflakes = {enabled = false},
        pylint = {enabled = false},
        flake8 = {enabled = false},
        pycodestyle = {enabled = false},
      },
    },
  },
}

-- Texlab
require('lspconfig')["texlab"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Rust Analyzer
require('lspconfig')['rust_analyzer'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
}


-- ---------------------
-- Customize diagnostics
-- ---------------------
vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    -- style = 'minimal',
    border = 'rounded',
    source = 'always',
    -- header = '',
    -- prefix = '',
  },
})
