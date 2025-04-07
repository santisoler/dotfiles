local function config_cmp()
	-- Define functions for Tab and Shift+Tab
	local has_words_before = function()
		unpack = unpack or table.unpack
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	local feedkey = function(key, mode)
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
	end
	---

	-- Set up nvim-cmp.
	local cmp = require("cmp")

	cmp.setup({
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			end,
		},
		window = {
			-- completion = cmp.config.window.bordered(),
			-- documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

			-- Use Tab and Shift+Tab to explore autocomplete options
			-- (source: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#super-tab-like-mapping)
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif vim.fn["vsnip#available"](1) == 1 then
					feedkey("<Plug>(vsnip-expand-or-jump)", "")
				elseif has_words_before() then
					cmp.complete()
				else
					fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
				end
			end, { "i", "s" }),

			["<S-Tab>"] = cmp.mapping(function()
				if cmp.visible() then
					cmp.select_prev_item()
				elseif vim.fn["vsnip#jumpable"](-1) == 1 then
					feedkey("<Plug>(vsnip-jump-prev)", "")
				end
			end, { "i", "s" }),
		}),

		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "vsnip" }, -- For vsnip users.
		}, {
			{ name = "buffer" },
		}),
	})

	-- Use buffer source for `/` and `?`
	-- (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- Use cmdline & path source for ':'
	-- (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
		matching = { disallow_symbol_nonprefix_matching = false },
	})
end

local function config_lsp()
	-- Configure nvim-cmp
	config_cmp()

	-- Setup servers
	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	-- Define LspAttach autocmd
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		desc = "LSP actions",
		callback = function()
			local opts = { buffer = true }
			-- Displays hover information about the symbol under the cursor
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			-- Jump to the definition
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			-- Jump to declaration
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			-- Lists all the implementations for the symbol under the cursor
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			-- Jumps to the definition of the type symbol
			vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
			-- Lists all the references
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			-- Displays a function's signature information
			vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
			-- Renames all references to the symbol under the cursor
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		end,
	})

	-- Lua lsp
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
	})

	-- Pylsp
	lspconfig.pylsp.setup({
		capabilities = capabilities,
		settings = {
			-- configure plugins in pylsp
			pylsp = {
				plugins = {
					pyflakes = { enabled = false },
					pylint = { enabled = false },
					flake8 = { enabled = false },
					pycodestyle = { enabled = false },
					jedi_completion = { fuzzy = true },
					pylsp_mypy = {
						-- needs pylsp-mypy
						-- (install with pip in the same environment as pylsp:
						-- https://github.com/python-lsp/python-lsp-server/discussions/546)
						enabled = true,
					},
				},
			},
		},
	})

	-- Ruff (python linter as lsp)
	lspconfig.ruff.setup({
		capabilities = capabilities,
		-- Configure settings: https://docs.astral.sh/ruff/editors/settings/#configuration
		init_options = {
			settings = {
				lint = {
					enable = true,
					extendSelect = { "F", "E", "ARG" },
				},
			},
		},
	})

	-- Rust analyzer
	lspconfig.rust_analyzer.setup({
		capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					enable = false,
				},
			},
		},
	})

	-- Emmet LSP
	lspconfig.emmet_language_server.setup({
		capabilities = capabilities,
	})
end

-- --------------
-- Manage plugins
-- --------------
--
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		config = config_lsp,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
		},
	},
}
