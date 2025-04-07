local function config()
	require("lualine").setup()
end

return {
	{
		"nvim-lualine/lualine.nvim",
		-- dependencies = { "nvim-tree/nvim-web-devicons" },
		config = config,
	},
}
