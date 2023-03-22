-- Configure telescope
-- -------------------
function live_git_grep()
  -- Run live_grep with git grep
  local prompt_title = "Git Grep"
  local vimgrep_arguments = {
    "git",
     "grep",
     "--full-name",
     "--line-number",
     "--column",
     "--extended-regexp",
     "--ignore-case",
     "--no-color",
     "--recursive",
     "--recurse-submodules",
     "-I"
  }
  local opts = {
    prompt_title=prompt_title,
    vimgrep_arguments=vimgrep_arguments,
  }
  require('telescope.builtin').live_grep(opts)
end

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fq', live_git_grep, {})
vim.keymap.set('n', '<leader>fl', builtin.git_files, {})
vim.keymap.set('n', '<leader>fs', builtin.git_status, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fe', builtin.resume, {})


-- Configure telescope
require('telescope').setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = { height = 0.95 },
  },
})



