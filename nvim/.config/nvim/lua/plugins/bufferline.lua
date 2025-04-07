local function config()
	vim.opt.termguicolors = true
	require("bufferline").setup({
		highlights = require("catppuccin.groups.integrations.bufferline").get(),
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
		dependencies = "nvim-tree/nvim-web-devicons",
		config = config,
	},
}
