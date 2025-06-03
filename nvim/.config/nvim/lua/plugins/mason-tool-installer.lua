local function config()
	require("mason-tool-installer").setup({
		ensure_installed = {
			-- LSPs
			-- "pyright",
			-- "python-lsp-server", -- pylsp
			-- "ruff",
			-- "ltex-ls",
			-- "lua-language-server",
			-- "rust-analyzer",
			-- "emmet-language-server",
			-- Linters
			"prettier",
			"rstcheck",
			"stylelint",
			"proselint",
			"shellcheck",
			"markdownlint-cli2",
			"write-good",
			-- "texlab",
			-- Autoformatters
			"stylua",
			-- Other packages
			"tree-sitter-cli",
		},
		run_on_start = true,
		auto_update = false,
	})
end

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = {
		"williamboman/mason.nvim",
	},
	config = config,
}
