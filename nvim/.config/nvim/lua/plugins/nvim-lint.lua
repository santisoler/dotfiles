-- Configure nvim-lint
-- -------------------

-- Configure nvim-lint
require('lint').linters_by_ft = {
  c= {'cppcheck'},
  python = {'flake8'},
  tex = {'chktex'},
  sh = {'shellcheck'},
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

