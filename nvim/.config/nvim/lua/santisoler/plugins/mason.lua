require("mason").setup()

-- Add function to install all packages in the following array
-- -----------------------------------------------------------

local MASON_PACKAGES = {
  "pyright",
  "python-lsp-server", -- pylsp
  "jedi-language-server",
  "black",
  "flake8",
  "mypy",
  "ruff",
  "prettier",
  "rstcheck",
  "stylelint",
  "proselint",
  "shellcheck",
  "markdownlint",
  "rust-analyzer",
  "tree-sitter-cli",
  "texlab",
  "lua-language-server",
  "ltex-ls",
}

function MasonAutoInstall(start_mason)

  if start_mason == nil then
    start_mason = true
  end

  local level = vim.log.levels.INFO
  local registry = require("mason-registry")

  for _, pkg_name in pairs(MASON_PACKAGES) do
    local package = registry.get_package(pkg_name)
    if not package:is_installed() then
      vim.notify("Installing " .. pkg_name, level)
      package:install()
    else
      vim.notify("Skipping " .. pkg_name, level)
    end
  end

  if start_mason then
    vim.api.nvim_command("Mason")
  end
end

-- Add function to install pylsp plugins in the same environment
-- -------------------------------------------------------------

function MasonInstallPylspPlugins()
  -- Installs pylsp plugins in the same environmetn as python-lsp-server
  -- Reference: https://github.com/williamboman/mason.nvim/issues/392

  local function mason_package_path(package)
      local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
      return path
  end

  -- depends on package manager / language
  local command = "/venv/bin/pip"
  local args = { "install", "pylsp-mypy" }

  print("Updating pylsp plugins...")
  require("plenary.job")
      :new({
          command = mason_package_path("python-lsp-server") .. command,
          args = args,
      })
      :start()
end
