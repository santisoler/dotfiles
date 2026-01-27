local function config()
	vim.opt.termguicolors = true
	require("bufferline").setup({
		highlights = require("catppuccin.special.bufferline").get_theme(),
		options = {
			offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
			separator_style = "thin",
			always_show_bufferline = false,
			show_close_icon = false,
		},
	})
end

return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		after = "catpuccin",
		-- dependencies = "nvim-tree/nvim-web-devicons",
		config = config,
	},
}
