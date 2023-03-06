require('dap-python').setup()
require("dapui").setup()

-- vim.keymap.set('n', '<leader>dn', 'lua require('dap-python').test_method()')
-- vim.keymap.set('n', '<leader>df', 'lua require('dap-python').test_class()')
-- vim.keymap.set('n', '<leader>ds', 'lua require('dap-python').debug_selection()')


vim.keymap.set('n', '<leader>dct', '<cmd>lua require"dap".continue()<CR>')
vim.keymap.set('n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>')
vim.keymap.set('n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>')
vim.keymap.set('n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>')
vim.keymap.set('n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>')

vim.keymap.set('n', '<leader>dsc', '<cmd>lua require"dap.ui.variables".scopes()<CR>')
vim.keymap.set('n', '<leader>dhh', '<cmd>lua require"dap.ui.variables".hover()<CR>')
vim.keymap.set('v', '<leader>dhv', '<cmd>lua require"dap.ui.variables".visual_hover()<CR>')

vim.keymap.set('n', '<leader>duh', '<cmd>lua require"dap.ui.widgets".hover()<CR>')
vim.keymap.set('n', '<leader>duf', "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>")

vim.keymap.set('n', '<leader>dsbr', '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>')
vim.keymap.set('n', '<leader>dsbm', '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
vim.keymap.set('n', '<leader>dro', '<cmd>lua require"dap".repl.open()<CR>')
vim.keymap.set('n', '<leader>drl', '<cmd>lua require"dap".repl.run_last()<CR>')

vim.keymap.set('n', '<leader>dui', '<cmd>lua require"dapui".toggle()<CR>')
