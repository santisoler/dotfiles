local function config()
	-- Configure nvim-lint
	require("lint").linters_by_ft = {
		c = { "cppcheck" },
		tex = { "proselint" },
		sh = { "shellcheck" },
		markdown = { "markdownlint-cli2", "proselint", "write_good" },
		gitcommit = { "proselint" },
		rst = { "rstcheck" },
		html = { "tidy" },
		htmldjango = { "tidy" },
		css = { "stylelint" },
	}

	-- Modify markdownlint options
	local markdownlintrc = vim.fn.expand("~") .. "/.markdownlint.jsonc"
	local markdownlint = require("lint.linters.markdownlint-cli2")
	markdownlint.args = {
		"--config",
		markdownlintrc,
	}

	-- Autorun linter on read and write
	vim.api.nvim_create_augroup("linter", { clear = true })
	vim.api.nvim_create_autocmd({ "BufNewFile", "BufEnter", "BufWritePost" }, {
		group = "linter",
		pattern = { "*" },
		callback = function()
			require("lint").try_lint()
		end,
	})
end

return {
	"mfussenegger/nvim-lint",
	config = config,
}
