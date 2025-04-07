-- Add function to install all packages in the following array
-- -----------------------------------------------------------
local MASON_PACKAGES = {
	-- LSPs
	"pyright",
	"python-lsp-server", -- pylsp
	"ruff",
	"ltex-ls",
	"lua-language-server",
	"rust-analyzer",
	"emmet-language-server",
	-- Linters
	"prettier",
	"rstcheck",
	"stylelint",
	"proselint",
	"shellcheck",
	"markdownlint-cli2",
	"write-good",
	-- "texlab",
	-- Autoformatters
	"stylua",
	-- Other packages
	"tree-sitter-cli",
}

function MasonAutoInstall(start_mason)
	if start_mason == nil then
		start_mason = true
	end

	-- Update Mason package list first
	vim.api.nvim_command("MasonUpdate")

	local level = vim.log.levels.INFO
	local registry = require("mason-registry")

	-- Install packages
	for _, pkg_name in pairs(MASON_PACKAGES) do
		local package = registry.get_package(pkg_name)
		if not package:is_installed() then
			vim.notify("Installing " .. pkg_name, level)
			package:install()
		else
			vim.notify("Skipping " .. pkg_name, level)
		end
	end

	-- Launch Mason if requested
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
			on_exit = function(j, return_val)
				print("Finished installing pylsp plugins.")
			end,
		})
		:start()
end

vim.api.nvim_create_user_command("MasonAutoInstall", MasonAutoInstall, {})
vim.api.nvim_create_user_command("MasonInstallPylspPlugins", MasonInstallPylspPlugins, {})

-- --------------
-- Manage plugins
-- --------------
--
return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
}
