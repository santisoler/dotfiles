local function config()
	require("catppuccin").setup({
		no_italic = true, -- Force no italic
		native_lsp = {
			enabled = true,
		},
	})
	-- setup must be done before loading
	vim.cmd.colorscheme("catppuccin")
end

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = config,
	},
}
