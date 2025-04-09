local function config()
	require("lualine").setup({
		options = {
			theme = "catppuccin-macchiato",
			section_separators = "",
			component_separators = "",
		},
	})
end

return {
	{
		"nvim-lualine/lualine.nvim",
		-- dependencies = { "nvim-tree/nvim-web-devicons" },
		config = config,
	},
}
