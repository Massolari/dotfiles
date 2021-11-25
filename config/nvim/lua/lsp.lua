local lsp_status = require('lsp-status')
local nvim_lsp = require("lspconfig")

local mappings = require("mappings")


local border = {
  -- {"🭽", "FloatBorder"},
  {"┌", "FloatBorder"},

  -- {"▔", "FloatBorder"},
  {"─", "FloatBorder"},

  -- {"🭾", "FloatBorder"},
  {"┐", "FloatBorder"},

  -- {"▕", "FloatBorder"},
  {"│", "FloatBorder"},

  -- {"🭿", "FloatBorder"},
  {"┘", "FloatBorder"},

  -- {"▁", "FloatBorder"},
  {"─", "FloatBorder"},

  -- {"🭼", "FloatBorder"},
  {"└", "FloatBorder"},

  -- {"▏", "FloatBorder"},
  {"│", "FloatBorder"},
}

local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  lsp_status.on_attach(client)
  client.config.capabilities = vim.tbl_extend('keep', client.config.capabilities or {}, lsp_status.capabilities)

  -- Mappings.
  mappings.lsp(client, bufnr)

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    if vim.opt.background:get() ~= 'light' then
      vim.api.nvim_exec(
        [[
        hi LspReferenceRead cterm=bold ctermbg=black guibg=black
        hi LspReferenceText cterm=bold ctermbg=black guibg=black
        hi LspReferenceWrite cterm=bold ctermbg=black guibg=black
        ]],
        false)
    else
      vim.api.nvim_exec(
        [[
        hi LspReferenceRead cterm=bold ctermbg=lightyellow guibg=lightyellow
        hi LspReferenceText cterm=bold ctermbg=lightyellow guibg=lightyellow
        hi LspReferenceWrite cterm=bold ctermbg=lightyellow guibg=lightyellow
        ]],
        false)
    end
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]],
      false)

  end

  if client.resolved_capabilities.code_lens then
    vim.api.nvim_exec(
      [[
      augroup lsp_code_lens_refresh
      autocmd! * <buffer>
      autocmd InsertLeave <buffer> lua vim.lsp.codelens.refresh()
      autocmd InsertLeave <buffer> lua vim.lsp.codelens.display()
      augroup END
      ]],
      false
    )
  end
  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
  vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      prefix = 'x', -- Could be '●', '▎', '■'
    },
  })

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.on_server_ready(function(server)
  local opts = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  -- (optional) Customize the options passed to the server
  -- if server.name == "tsserver" then
  --     opts.root_dir = function() ... end
  -- end
  -- if server.name == "tailwindcss" then
  --   opts.settings = {
  --     tailwindCSS = {
  --       -- includeLanguages = {
  --       --   elm = "html"
  --       -- },
  --       experimental = {
  --         classRegex = "\\bclass\\s+\"([^\"]*)\""
  --       }
  --     }
  --   }
  --   opts.init_options = {
  --     userLanguages = {
  --       elm = "html"
  --     }
  --   }
  --   opts.filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "django-html", "edge", "eelixir", "ejs", "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "elm" }
  -- end

  -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)
