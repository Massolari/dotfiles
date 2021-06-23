local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

local opts = { noremap=true, silent=true }

local function setup()
    print("begin setup")
    -- buf_set_keymap('t', 'jk', '<c-\\><c-n>', {})
    -- buf_set_keymap('t', 'kj', '<C-\\><C-n>', {})

    -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "single" }})<CR>', opts)
    -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "single" }})<CR>', opts)
    print("end setup")
end

local function lsp(client)
    print("begin lsp")
    buf_set_keymap('n', '<leader>ca', "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap('n', '<leader>co', "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
    buf_set_keymap('n', '<leader>cp', "<cmd>lua vim.lsp.buf.workspace_symbol('')<CR>", opts)
    buf_set_keymap('n', 'gd', '<cmd>vim.lsp.buf.definition()<CR>', opts)
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
    print("end lsp")
end

local M = {
    lsp = lsp,
    setup = setup
}

return M
