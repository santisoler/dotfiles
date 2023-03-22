-- Configure telescope
-- -------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>fs', builtin.git_status, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fe', builtin.resume, {})
vim.keymap.set('n', '<leader>fl', builtin.find_files, {})

-- Configure layout of telescope
require('telescope').setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = { height = 0.95 },
    -- configure live_grep to run git grep
    vimgrep_arguments = {
      "git", "grep", "--full-name", "--line-number", "--column", "--extended-regexp", "--ignore-case",
      "--no-color", "--recursive", "--recurse-submodules", "-I"
    },
    --
  },
})
