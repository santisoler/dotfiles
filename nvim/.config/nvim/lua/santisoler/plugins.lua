-- =================================
-- Install plugins using packer.nvim
-- =================================

-- -----------------------
-- Autoinstall packer.nvim
-- -----------------------
local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer. Close and reopen Neovim."
    vim.cmd [[packadd packer.nvim]]
end


-- ---------------
-- Install plugins
-- ---------------
return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Mason (package manager for LSPs)
  use {
    "williamboman/mason.nvim",
    run = ":MasonUpdate", -- :MasonUpdate updates registry contents
    config = function() require('santisoler.plugins.mason') end,
  }

  -- Catpuccin theme
  use {
    "catppuccin/nvim",
    as = "catppuccin" ,
    config = function() require('santisoler.plugins.catppuccin') end,
  }

  -- Git
  use {
    'tpope/vim-fugitive',
    config = function() require('santisoler.plugins.fugitive') end,
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('santisoler.plugins.gitsigns') end,
  }

  -- Surrounding characters
  use 'tpope/vim-surround'

  -- LaTeX
  use {
    'lervag/vimtex',
    config = function() require('santisoler.plugins.vimtex') end,
  }

  -- Webdev
  use 'ap/vim-css-color'
  use {
    'mattn/emmet-vim',
    -- pin to this version because emmet wasn't working on markdown files
    -- reference: https://github.com/mattn/emmet-vim/issues/559
    commit = "3fb2f63799e1922f7647ed9ff3b32154031a76ee",
  }

  -- Autoformat files
  use {
    'sbdchd/neoformat',
    config = function() require('santisoler.plugins.neoformat') end,
  }

  -- Vimwiki
  use {
    'vimwiki/vimwiki',
    config = function() require('santisoler.plugins.vimwiki') end,
  }

  -- Comment.nvim
  use {
    'numToStr/Comment.nvim',
    config = function() require('santisoler.plugins.comment') end,
  }

  -- nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    config = function() require('santisoler.plugins.nvim-tree') end,
  }

  -- lualine.nvim
  use {
    'nvim-lualine/lualine.nvim',
    config = function() require('santisoler.plugins.lualine') end,
  }

  -- bufferline
  use {
    'akinsho/bufferline.nvim',
    after="catppuccin",
    config = function() require('santisoler.plugins.bufferline') end,
  }

  -- -- nvim-autopairs
  -- use {
  --   "windwp/nvim-autopairs",
  --   config = function() require("nvim-autopairs").setup {} end
  -- }

  -- nvim-lint
  use {
    'mfussenegger/nvim-lint',
    config = function() require('santisoler.plugins.nvim-lint') end,
  }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function() require('santisoler.plugins.lspconfig') end,
  }

  -- cmp
  use {
    'hrsh7th/nvim-cmp',
    config = function() require('santisoler.plugins.cmp') end,
    requires = {
      'hrsh7th/cmp-nvim-lsp',     -- LSP source for nvim-cmp
      'hrsh7th/cmp-path',         -- complete paths with nvim-cmp
      'hrsh7th/vim-vsnip',        -- Snippets plugin
      'hrsh7th/cmp-vsnip',
    }
  }

  -- Tree-sitter and:
  --   * treesitter-context
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('santisoler.plugins.treesitter')
    end,
    requires = {
      'nvim-treesitter/nvim-treesitter-context',
    },
  }

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function() require('santisoler.plugins.telescope') end,
  }

  -- iron.nvim (send lines to a REPL)
  use {
    'Vigemus/iron.nvim',
    config = function() require('santisoler.plugins.iron') end,
  }

  -- neogen (autogenerate docstrings)
  use {
    "danymat/neogen",
    config = function()
        require('santisoler.plugins.neogen')
    end,
    requires = "nvim-treesitter/nvim-treesitter",
    -- Uncomment next line if you want to follow only stable versions
    tag = "*"
  }

  -- undotree
  use {
    'mbbill/undotree',
  }

  -- nvim-coverage
  use({
    "andythigpen/nvim-coverage",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("coverage").setup({
          signs = {
            -- use your own highlight groups or text markers
            covered = { hl = "CoverageCovered", text = "✓" },
            uncovered = { hl = "CoverageUncovered", text = "✗" },
            partial = { hl = "CoveragePartial", text = "!" },
          },
      })
    end,
  })

  -- fold
  use {
    'kevinhwang91/nvim-ufo',
    requires = 'kevinhwang91/promise-async',
    config = function()
        require('santisoler.plugins.nvim-ufo')
    end,
  }

end)
