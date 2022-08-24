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

  -- Nord theme
  use 'arcticicestudio/nord-vim'

  -- Git
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('plugins.gitsigns') end,
  }

  -- Surrounding characters
  use 'tpope/vim-surround'

  -- LaTeX
  use {
    'lervag/vimtex',
    config = function() require('plugins.vimtex') end,
  }

  -- Webdev
  use 'ap/vim-css-color'
  use {
    'mattn/emmet-vim',
     config = function()
         vim.g.user_emmet_leader_key = '<C-Z>'
     end
  }

  -- Autoformat files
  use {
    'sbdchd/neoformat',
    config = function() require('plugins.neoformat') end,
  }

  -- Vimwiki
  use {
    'vimwiki/vimwiki',
    config = function() require('plugins.vimwiki') end,
  }

  -- Comment.nvim
  use {
    'numToStr/Comment.nvim',
    config = function() require('plugins.comment') end,
  }

  -- nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    config = function() require('plugins.nvim-tree') end,
  }

  -- lualine.nvim
  use {
    'nvim-lualine/lualine.nvim',
    config = function() require('plugins.lualine') end,
  }

  -- bufferline
  use {
    'akinsho/bufferline.nvim',
    config = function() require('plugins.bufferline') end,
  }

  -- nvim-autopairs
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

  -- nvim-lint
  use {
    'mfussenegger/nvim-lint',
    config = function() require('plugins.nvim-lint') end,
  }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function() require('plugins.lspconfig') end,
  }

  -- cmp
  use {
    'hrsh7th/nvim-cmp',
    config = function() require('plugins.cmp') end,
    requires = {
      'hrsh7th/cmp-nvim-lsp',     -- LSP source for nvim-cmp
      'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
      'hrsh7th/cmp-path',         -- complete paths with nvim-cmp
      'L3MON4D3/LuaSnip',         -- Snippets plugin
    }
  }

  -- Tree-sitter and spellsitter (don't spellcheck variables)
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('plugins.treesitter') end,
    requires = 'lewis6991/spellsitter.nvim',
  }

  -- toggle lsp diagnostics
  use {
    'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim',
    config = function() require('plugins.toggle-lsp-diagnostics') end,
  }

  -- trouble.nvim (show list of diagnostics)
  use {
    "folke/trouble.nvim",
    config = function() require('plugins.trouble') end,
  }

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function() require('plugins.telescope') end,
  }

  -- vim-python-pep8-indent
  use {
    'Vimjas/vim-python-pep8-indent',
  }

end)
