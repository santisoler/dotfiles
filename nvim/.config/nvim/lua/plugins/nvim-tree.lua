local function config()
	require("nvim-tree").setup({
		filters = { dotfiles = true },
		actions = {
			open_file = {
				quit_on_open = true,
			},
		},
	})
	vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
	-- vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>")
end

return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			-- "nvim-tree/nvim-web-devicons",
		},
		config = config,
	},
}
