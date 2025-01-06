-- -------------------
-- Configure telescope
-- -------------------

-- function is_git_repo()
--   -- Check if we are inside a git repo
--   local status = os.execute("git rev-parse --show-toplevel 1> /dev/null 2> /dev/null")
--   if status == 0 then
--     return true
--   end
--   return false
-- end


function live_git_grep()
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
     "-I"
  }
  local opts = {
    prompt_title="Git Grep",
    vimgrep_arguments=vimgrep_arguments,
  }
  require('telescope.builtin').live_grep(opts)
end


-- function find_files()
--   -- Find files with find_files or git_files
--   if is_git_repo() then
--     require('telescope.builtin').git_files()
--   else
--     require('telescope.builtin').find_files()
--   end
-- end


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>fl', live_git_grep, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fm', builtin.marks, {})
vim.keymap.set('n', '<leader>fs', builtin.git_status, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fr', builtin.resume, {})


-- Configure telescope
require('telescope').setup({
  defaults = {
    layout_strategy = "flex",
    -- layout_config = { height = 0.95 },
  },
})
