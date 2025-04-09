-- Customize the LspAttach autocmd
-- ===============================

-- Nvim ships with a builtin LspAttach autocmd that has some default
-- keybindings that are set when an Lsp is attached. We can override and
-- configure some more keybindings and configs.
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		-- Disable the formatexpr set by the lsp.
		-- Needed to avoid ruff not allowing us to use gq.
		-- Reference: https://github.com/astral-sh/ruff/issues/11634
		vim.bo[args.buf].formatexpr = nil

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = args.buf }
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
		-- Trigger autoformat
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})
