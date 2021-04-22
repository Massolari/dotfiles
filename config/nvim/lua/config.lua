vim.lsp.set_log_level("debug")

local lsp_status = require('lsp-status')
lsp_status.register_progress()

local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    lsp_status.on_attach(client)
    client.config.capabilities = vim.tbl_extend('keep', client.config.capabilities or {}, lsp_status.capabilities)

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', '<leader>ca', "<cmd>lua require'fzf_lsp'.code_action_call{}<CR>", opts)
    -- buf_set_keymap('n', '<leader>cd', "<cmd>lua require'fzf_lsp'.diagnostic_call{}<CR>", opts)
    buf_set_keymap('n', '<leader>co', "<cmd>lua require'fzf_lsp'.document_symbol_call{}<CR>", opts)
    buf_set_keymap('n', '<leader>cp', "<cmd>lua require'fzf_lsp'.workspace_symbol_call{}<CR>", opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- buf_set_keymap('n', 'K', "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap('n', 'K', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>cs', "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", opts)
    buf_set_keymap('n', 'gy', "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', "<cmd>lua require'fzf_lsp'.references_call{}<CR>", opts)
    -- buf_set_keymap('n', '<leader>ce', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "single" })<CR>', opts)
    buf_set_keymap('n', '<leader>ce', "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", opts)
    buf_set_keymap('n', '[d', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", opts)
    buf_set_keymap('n', ']d', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", opts)

    -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "single" }})<CR>', opts)
    -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "single" }})<CR>', opts)
    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=black
        hi LspReferenceText cterm=bold ctermbg=red guibg=black
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=black
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end

local servers = { "cssls", "gopls", "html", "jsonls", "tsserver", "vimls", "yamlls", "elmls" }

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        capabilities = capabilities,
        on_init = function(client)
            client.config.flags = {}
            if client.config.flags then
                client.config.flags.allow_incremental_sync = true
            end
        end,
        on_attach = on_attach
    }
end

require'lspconfig'.elixirls.setup {
    capabilities = capabilities,
    cmd = { "/home/massolari/elixir-ls/language_server.sh" },
    on_attach = on_attach,
    settings = {
        elixirLS = {
            dialyzerEnabled = false,
            suggestSpecs = false
        }
    }
}

require'compe'.setup {
    source = {
        path = true;
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        tabnine = true;
        vsnip = false;
    };
}

local saga = require 'lspsaga'
saga.init_lsp_saga()

require('lspkind').init()

require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,              -- false will disable the whole extension
    },
}

require"toggleterm".setup{
    open_mapping = [[<c-\>]],
    shade_terminals = false,
    direction = 'horizontal'
}

require'trouble'.setup{}
