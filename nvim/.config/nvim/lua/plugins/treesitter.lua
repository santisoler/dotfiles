local function config_treesitter()
	local configs = require("nvim-treesitter.configs")

	configs.setup({
		ensure_installed = {
			"python",
			"lua",
			"c",
			"rust",
			"latex",
			"vimdoc",
			"html",
		},
		sync_install = false,
		highlight = { enable = true },
		indent = {
			enable = true,
			-- Disable treesitter indent for Python and Markdown
			disable = { "python", "markdown" },
		},
	})
end

local function config_treesitter_context()
	-- Configure treesitter-context
	require("treesitter-context").setup({
		multiline_threshold = 1, -- Maximum number of lines to show for a single context
	})

	-- Set keybinding to go to last context
	vim.keymap.set("n", "[n", function()
		require("treesitter-context").go_to_context()
	end, { silent = true })
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"williamboman/mason.nvim", --depend on mason to install tree-sitter first
		},
		build = { ":MasonInstall tree-sitter-cli", ":TSUpdate" },
		config = config_treesitter,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = config_treesitter_context,
	},
}
