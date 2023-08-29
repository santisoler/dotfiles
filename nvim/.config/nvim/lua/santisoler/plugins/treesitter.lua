require("nvim-treesitter.configs").setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "lua", "latex", "c", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = false,
  },

  -- Configure nvim-yati (alternative indentation for treesitter)
  yati = {
    enable = true,

    -- Disable by languages, see `Supported languages`
    -- disable = { "python" },

    -- Whether to enable lazy mode (recommend to enable this if bad indent happens frequently)
    default_lazy = true,

    -- Determine the fallback method used when we cannot calculate indent by tree-sitter
    --   "auto": fallback to vim auto indent
    --   "asis": use current indent as-is
    --   "cindent": see `:h cindent()`
    -- Or a custom function return the final indent result.
    default_fallback = "auto"
  },

  indent = {
    enable = false -- disable builtin indent module (needed by yati)
  }

}

require('treesitter-context').setup{
  multiline_threshold = 1, -- Maximum number of lines to show for a single context
}
