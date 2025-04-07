return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "williamboman/mason.nvim", --depend on mason to install tree-sitter first
    },
    build = {":MasonInstall tree-sitter-cli", ":TSUpdate"},
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = {
            "python",
            "lua",
            "c",
            "rust",
            "latex",
            "vimdoc",
            "html",
          },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
    end
   }
 }
