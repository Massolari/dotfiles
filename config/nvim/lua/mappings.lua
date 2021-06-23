local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function set_keymap(...) vim.api.nvim_set_keymap(...) end

local opts = { noremap=true, silent=true }

local function setup()
    -- Ir para modo normal no terminal de forma rapida
    set_keymap('t', 'jk', '<c-\\><c-n>', opts)
    set_keymap('t', 'kj', '<C-\\><C-n>', opts)


    -- Navegar pelo histórico de comando levando em consideração o que foi digitado
    set_keymap('c', '<c-k>', '<Up>', {})
    set_keymap('c', '<c-j>', '<Down>', {})

    -- Mover no modo insert sem as setas
    set_keymap('i', '<c-b>', '<left>', opts)
    set_keymap('i', '<c-j>', '<down>', opts)
    set_keymap('i', '<c-k>', '<up>', opts)
    set_keymap('i', '<c-l>', '<right>', opts)

    -- Diagnostics
    set_keymap('n', '<leader>cd', '<cmd>Trouble<cr>', opts)

    set_keymap('n', '<c-f>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opts)
    set_keymap('n', '<c-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", opts)

    -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "single" }})<CR>', opts)
    -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "single" }})<CR>', opts)
end

local function lsp(client)
    buf_set_keymap('n', '<leader>ca', "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap('n', '<leader>co', "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
    buf_set_keymap('n', '<leader>cp', "<cmd>lua vim.lsp.buf.workspace_symbol('')<CR>", opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- buf_set_keymap('n', 'K', "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap('n', 'K', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<leader>cs', "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", opts)
    buf_set_keymap('n', 'gy', "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    -- buf_set_keymap('n', '<leader>ce', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "single" })<CR>', opts)
    buf_set_keymap('n', '<leader>ce', "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", opts)
    buf_set_keymap('n', '[d', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", opts)
    buf_set_keymap('n', ']d', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", opts)
    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
end

local M = {
    lsp = lsp,
    setup = setup
}

return M
