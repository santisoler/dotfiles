-- Configure nvim-lint
require('lint').linters_by_ft = {
  c= {'cppcheck'},
  python = {'flake8',},
  tex = {'chktex', 'lacheck'},
  sh = {'shellcheck'},
}
