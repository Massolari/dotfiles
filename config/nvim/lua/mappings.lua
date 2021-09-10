local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function set_keymap(...) vim.api.nvim_set_keymap(...) end

local function set_keymaps(mode, list)
    for _, map in pairs(list) do
        set_keymap(mode, unpack(map))
    end
end

local opts = { noremap=true, silent=true }

local command = {
    -- Navegar pelo histórico de comando levando em consideração o que foi digitado
    {'<c-k>', '<Up>', {}},
    {'<c-j>', '<Down>', {}}
}

local insert = {
    -- Mover no modo insert sem as setas
    {'<c-b>', '<left>', opts},
    {'<c-j>', '<down>', opts},
    {'<c-k>', '<up>', opts},
    {'<c-l>', '<right>', opts}
}

local normal = {
    -- Diagnostics
    {'<leader>cd', '<cmd>Trouble<cr>', opts},

    -- Rolar texto do janela do lspsaga
    {'<c-f>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opts},
    {'<c-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", opts},

    -- Navegar pelos buffers
    {'<tab>', "<cmd>BufferLineCycleNext<CR>", opts},
    {'<s-tab>', "<cmd>BufferLineCyclePrev<CR>", opts},

    -- Alternar para arquivo
    {'<leader>bb', "<cmd>lua require'fzf-lua'.buffers()<CR>", opts},

    -- Abrir arquivo
    {'<leader>pf', "<cmd>lua require'fzf-lua'.files()<CR>", opts},

    -- Procurar em arquivos
    {'<leader>ps', "<cmd>FzfLua grep<CR>", opts},

    -- Procurar em arquivos palavra sob o cursor
    {'<leader>pe', "<cmd>lua require'fzf-lua'.grep_cword()<CR>", opts},

    -- Git log
    {'<leader>gg', "<cmd>lua require'fzf-lua'.git_commits()<CR>", opts},

    -- Git branch
    {'<leader>gr', "<cmd>lua require'fzf-lua'.git_branches()<CR>", opts},

    -- Git push
    {'<leader>gp', "<cmd>Git -c push.default=current push<CR>", opts},

    -- Git checkout -b
    {'<leader>gk', "<cmd>lua require'mappings'.checkout_new_branch()<CR>", opts},

    -- Colorschemes
    {'<leader>ec', "<cmd>lua require'fzf-lua'.colorschemes()<CR>", opts},

    -- FZF Lines
    {'<c-_>', "<cmd>lua require'fzf-lua'.blines()<CR>", opts},
}

local terminal = {
    -- Ir para modo normal no terminal de forma rapida
    {'jk', '<c-\\><c-n>', opts},
    {'kj', '<C-\\><C-n>', opts}
}

local function setup()
    set_keymaps('t', terminal)
    set_keymaps('i', insert)
    set_keymaps('c', command)
    set_keymaps('n', normal)
end

local function lsp(client)
    buf_set_keymap('n', '<leader>ca', "<cmd>lua require'fzf-lua'.lsp_code_actions()<CR>", opts)
    buf_set_keymap('n', '<leader>co', "<cmd>lua require'fzf-lua'.lsp_document_symbols({ fzf_cli_args = '--with-nth 2,-1' })<CR>", opts)
    buf_set_keymap('n', '<leader>cp', "<cmd>lua require'fzf-lua'.lsp_workspace_symbols('')<CR>", opts)
    -- buf_set_keymap('n', 'gd', "<cmd>lua require'fzf-lua'.lsp_definitions()<CR>", opts)
    buf_set_keymap('n', 'gd', "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    -- buf_set_keymap('n', 'K', "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap('n', 'K', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
    buf_set_keymap('n', 'gi', "<cmd>lua require'fzf-lua'.lsp_implementations()<CR>", opts)
    buf_set_keymap('n', '<leader>cs', "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", opts)
    buf_set_keymap('n', 'gy', "<cmd>lua require'fzf-lua'.lsp_typedefs()<CR>", opts)
    buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', "<cmd>lua require'fzf-lua'.lsp_references()<CR>", opts)
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

local function checkout_new_branch()
    local branch_name = vim.fn.input("New branch name> ")
    if branch_name == "" then
        return
    end
    vim.cmd('echo "\r"')
    vim.cmd("echohl Directory")
    vim.cmd(":Git checkout -b " .. branch_name)
    vim.cmd("echohl None")
end

local M = {
    lsp = lsp,
    checkout_new_branch = checkout_new_branch,
}

setup()

return M
