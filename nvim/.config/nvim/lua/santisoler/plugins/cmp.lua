-- Require needed packages
-- -----------------------
local luasnip = require 'luasnip'
local cmp = require 'cmp'

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- -------------
-- Configure cmp
-- -------------
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
    preselect=true,
  },

  -- Define keybindings
  mapping = cmp.mapping.preset.insert({

    -- Start completion
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- navigate items in the list
    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    -- Scroll docs
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    -- Smart tab
    ["<Tab>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
      -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
      -- they way you will only jump inside the snippet region
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  -- Configure sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

-- Define function to toggle autocompletion
function set_autocompletion(mode)
  if mode then
    cmp.setup({
      completion = {
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
      }
    })
  else
    cmp.setup({
      completion = {
        autocomplete = false
      }
    })
  end
end

-- enable automatic completion popup on typing
vim.cmd('command EnableAutocompletion lua set_autocompletion(true)')

-- disable automatic competion popup on typing
vim.cmd('command DisableAutocompletion lua set_autocompletion(false)')
