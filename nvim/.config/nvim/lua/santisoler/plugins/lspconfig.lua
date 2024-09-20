-- ====================
-- Configure lsp-config
-- ====================
local lspconfig = require('lspconfig')
local util = require('lspconfig/util')

-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

--Enable (broadcasting) snippet capability for completion (only for vscode ls)
local vscode_capabilities = vim.lsp.protocol.make_client_capabilities()
vscode_capabilities.textDocument.completion.completionItem.snippetSupport = true


-- C language server
lspconfig.ccls.setup {
  capabilities = capabilities,
}

-- Bash language server
lspconfig.bashls.setup {
  capabilities = capabilities,
}

-- Define which python lsp to use
local python_lsp = "pylsp"

if python_lsp == "pyright" then
  lspconfig.pyright.setup {
    -- Use the following capabilities to disable pyright diagnostics
    capabilities = {
      textDocument = {
        publishDiagnostics = {
          tagSupport = {
            valueSet = { 2 },
          },
        },
      },
    },
    -- change default settings to make it run faster
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly", -- default to "workspace"
          useLibraryCodeForTypes = true
        }
      }
    },
    -- avoid running pyright running on the entire home directory
    -- (https://github.com/microsoft/pyright/issues/4176)
    root_dir = function()
      return vim.fn.getcwd()
    end,
  }
elseif python_lsp == "pylyzer" then
  lspconfig.pylyzer.setup{
    capabilities = capabilities,
    settings = {
      python = {
        checkOnType = true,
        diagnostics = true,
        inlayHints = true,
        smartCompletion = true
      }
    },
  }
elseif python_lsp == "jedi" then
  lspconfig.jedi_language_server.setup{
    capabilities = capabilities,
  }
elseif python_lsp == "pylsp" then
  lspconfig.pylsp.setup {
    capabilities = capabilities,
    settings = {
      -- configure plugins in pylsp
      pylsp = {
        plugins = {
          pyflakes = {enabled = false},
          pylint = {enabled = false},
          flake8 = {enabled = false},
          pycodestyle = {enabled = false},
          -- pylsp_mypy = { enabled = true }, -- needs pylsp-mypy (install with pip in the same environment as pylsp: https://github.com/python-lsp/python-lsp-server/discussions/546)
          jedi_completion = { fuzzy = true },
        },
      },
    },
  }
end

-- Ruff (python linter as lsp)
lspconfig.ruff.setup {
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}

-- Texlab
lspconfig.texlab.setup {
  capabilities = capabilities,
}

-- Rust Analyzer
lspconfig.rust_analyzer.setup{
  capabilities = capabilities,
  root_dir = util.root_pattern("Cargo.toml"),
  settings = {
    ['rust_analyzer'] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
}

-- lua lsp
lspconfig.lua_ls.setup {
  capabilities = capabilities,
}

-- html lsp
lspconfig.html.setup {
  capabilities = vscode_capabilities,
}

-- css lsp
lspconfig.cssls.setup {
  capabilities = vscode_capabilities,
}

-- ltex-ls
-- lspconfig.ltex.setup {
--  cmd = { "ltex-ls" },
--  filetypes = { "markdown", "tex", "gitcommit", "rst" },
--  flags = { debounce_text_changes = 300 },
--  capabilities = vscode_capabilities,
-- }


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)


-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Disable the formatexpr set by the lsp.
    -- Needed to avoid ruff not allowing us to use gq.
    -- Reference: https://github.com/astral-sh/ruff/issues/11634
    vim.bo[ev.buf].formatexpr = nil

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
