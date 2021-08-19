vim.lsp.set_log_level("debug")

local lsp_status = require('lsp-status')
lsp_status.register_progress()

local nvim_lsp = require("lspconfig")

local mappings = require("mappings")
mappings.setup()

local on_attach = function(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    lsp_status.on_attach(client)
    client.config.capabilities = vim.tbl_extend('keep', client.config.capabilities or {}, lsp_status.capabilities)

    -- Mappings.
    mappings.lsp(client)

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
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}
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
        ultisnips = true;
    };
}

-- vim.g.coq_settings = {
--     auto_start = true,
--     keymap = {
--         recommended = false,
--         jump_to_mark = "<c-t>",
--         bigger_preview = "<c-s>",
--     },
--     clients = {
--         ['tabnine.enabled'] = true
--     }
-- }

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

require'trouble'.setup{
    auto_preview = false,
    signs = {
        -- icons / text used for a diagnostic
        error = " - Err - ",
        warning = " - War - ",
        hint = " - Hin - ",
        information = " - Inf - "
    },
}

require'lightspeed'.setup {
   jump_to_first_match = true,
   jump_on_partial_input_safety_timeout = 400,
   highlight_unique_chars = false,
   grey_out_search_area = true,
   match_only_the_start_of_same_char_seqs = true,
   limit_ft_matches = 5,
   full_inclusive_prefix_key = '<c-x>',
}
for _, key in ipairs({'f', 'F', 't', 'T'}) do
    vim.api.nvim_del_keymap('o', key)
    vim.api.nvim_del_keymap('x', key)
    vim.api.nvim_del_keymap('n', key)
end

require('gitsigns').setup {
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    ['n <leader>ghu'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <leader>ghu'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>ghv'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
  current_line_blame = true,
  current_line_blame_delay = 0,
}

require'lspfuzzy'.setup{}
