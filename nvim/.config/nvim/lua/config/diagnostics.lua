-- ---------------------
-- Configure diagnostics
-- ---------------------

vim.diagnostic.config({
	virtual_text = true,
	signs = false,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		focusable = true,
		border = "rounded",
		source = "always",
		suffix = "",
		prefix = function(diagnostic)
			-- Function to show error code in diagnostics
			-- Idea got from docs (:h diagnostic-quickstart)
			local condition = (diagnostic.source == "flake8" or diagnostic.source == "Ruff")
			if condition then
				return "[" .. diagnostic.code .. "] "
			end
		end,
		header = "",
	},
})

-- Add border to LSP floating windows globally
-- Reference: https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
local border = "rounded"
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Define commands to enable/disable diagnostics
vim.cmd("command DisableDiagnostics lua vim.diagnostic.disable()")
vim.cmd("command EnableDiagnostics lua vim.diagnostic.enable()")

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
