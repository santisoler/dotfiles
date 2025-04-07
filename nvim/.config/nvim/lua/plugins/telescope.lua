local function live_git_grep()
	-- Run live_grep with defaults or with git grep
	local vimgrep_arguments = {
		"git",
		"grep",
		"--line-number",
		"--column",
		"--extended-regexp",
		"--ignore-case",
		"--no-color",
		"--recursive",
		"--recurse-submodules",
		"-I",
	}
	local opts = {
		prompt_title = "Git Grep",
		vimgrep_arguments = vimgrep_arguments,
	}
	require("telescope.builtin").live_grep(opts)
end

local function config()
	-- Define keybinding
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
	vim.keymap.set("n", "<leader>fl", builtin.live_grep, {})
	vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
	vim.keymap.set("n", "<leader>gl", live_git_grep, {})
	vim.keymap.set("n", "<leader>fm", builtin.marks, {})
	vim.keymap.set("n", "<leader>fs", builtin.git_status, {})
	vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {})
	vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
	vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
	vim.keymap.set("n", "<leader>fr", builtin.resume, {})

	-- Configure telescope
	require("telescope").setup({
		defaults = {
			layout_strategy = "flex",
			-- layout_config = { height = 0.95 },
		},
	})
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = config,
}
