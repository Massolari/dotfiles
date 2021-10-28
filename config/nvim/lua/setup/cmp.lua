local cmp = require'cmp'
local lspkind = require'lspkind'
local luasnip = require'luasnip'

local sources ={
  { name = 'nvim_lsp' },
  { name = 'cmp_tabnine' },
  { name = 'luasnip' },
  { name = 'path' },
  { name = 'buffer' },
  { name = 'calc' },
  { name = 'emoji' },
}

-- Filter sources table using vim.g.disabled_cmp_sources variable that is a list of names
local disabled_sources = vim.g.disabled_cmp_sources or {}
local enabled_sources = {}
for _, source in ipairs(sources) do
  if not disabled_sources[source.name] then
    table.insert(enabled_sources, source)
  end
end

cmp.setup({
  snippet = {
    expand = function(args)
      -- vim.fn["UltiSnips#Anon"](args.body)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = function(fallback)
      if luasnip.jumpable(1) then
        -- if luasnip.expand_or_jumpable() then
        -- vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-next', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind] .. " " .. vim_item.kind
      vim_item.menu = ({
        path = "[Path]",
        buffer = "[Buffer]",
        calc = "[Calc]",
        nvim_lsp = "[LSP]",
        cmp_tabnine = "[TabNine]",
        luasnip = "[LuaSnip]",
        emoji = "[Emoji]",
      })[entry.source.name]
      return vim_item
    end
  },
  sources = enabled_sources,
  experimental = {
    native_menu = false,
    ghost_text = true
  }
})


