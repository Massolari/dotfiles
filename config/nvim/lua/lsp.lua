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
  mappings.lsp(client)

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    if vim.opt.background:get() ~= 'light' then
      vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=black guibg=black
      hi LspReferenceText cterm=bold ctermbg=black guibg=black
      hi LspReferenceWrite cterm=bold ctermbg=black guibg=black
      ]], false)
    else
      vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=lightyellow guibg=lightyellow
      hi LspReferenceText cterm=bold ctermbg=lightyellow guibg=lightyellow
      hi LspReferenceWrite cterm=bold ctermbg=lightyellow guibg=lightyellow
      ]], false)
    end
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
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

local function setup_servers()
  require'lspinstall'.setup() -- important
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    nvim_lsp[server].setup{
      capabilities = capabilities,
      on_attach = on_attach
    }
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

function _G.lsp_reinstall_all()
  local lspinstall = require'lspinstall'
  for _, server in ipairs(lspinstall.installed_servers()) do
    lspinstall.install_server(server)
  end
end

vim.cmd 'command! -nargs=0 LspReinstallAll call v:lua.lsp_reinstall_all()'
