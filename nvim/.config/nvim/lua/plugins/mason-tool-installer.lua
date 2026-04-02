local function config()
	require("mason-tool-installer").setup({
		ensure_installed = {
			-- LSPs are handled by mason-lspconfig in lspconfig.lua
			-- Linters
			"prettier",
			"rstcheck",
			"stylelint",
			"proselint",
			"shellcheck",
			-- "markdownlint-cli2", -- consumes too much ram from time to time
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
