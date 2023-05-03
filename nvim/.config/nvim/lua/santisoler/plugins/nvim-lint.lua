-- Configure nvim-lint
-- -------------------

-- Configure nvim-lint
require('lint').linters_by_ft = {
  c= {'cppcheck'},
  python = {'flake8'},
  tex = {'chktex', 'proselint'},
  sh = {'shellcheck'},
  markdown = {'markdownlint', 'proselint'},
  rst = {'rstcheck'},
  html = {'tidy'},
  htmldjango = {'tidy'},
}

-- Modify flake8 options
local flake8 = require('lint.linters.flake8')
flake8.args = {
  -- <- Add a new parameter here
  '--max-line-length=88',
  -- <--
  '--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s',
  '--no-show-source',
  '-',
}

-- Modify markdownlint options
local markdownlint = require('lint.linters.markdownlint')
markdownlint.args = {
  '--disable',
  'MD012',
  '--',
}

-- Autorun linter on read and write
vim.api.nvim_create_augroup("linter", { clear = true })
vim.api.nvim_create_autocmd({"BufNewFile", "BufEnter", "BufWritePost"}, {
    group = "linter",
    pattern = { "*" },
    callback = function()
      require("lint").try_lint()
    end,
})


