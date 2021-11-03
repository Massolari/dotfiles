local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function set_keymap(...) vim.api.nvim_set_keymap(...) end

local function set_keymaps(mode, list)
  for _, map in pairs(list) do
    set_keymap(mode, unpack(map))
  end
end

local opts = { noremap=true, silent=true }

local function command_with_args(prompt, default, completion, command)
  local input = vim.fn.input(prompt, '', completion)
  if input == '' and default ~= nil then
    input = default
  end
  vim.cmd(":" .. command .. " " .. input)
end

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
  {'<c-l>', '<right>', opts},

  -- Ir para o normal mode mais rapidamente
  { 'jk', '<Esc>', opts },
  { 'kj', '<Esc>', opts },
}

local normal = {
  -- Desfazer mapeamentos do lightspeed
  {'f', 'f', {}},
  {'F', 'F', {}},
  {'t', 't', {}},
  {'T', 'T', {}},

  -- Diagnostics
  {'<leader>cd', '<cmd>Trouble<cr>', opts},

  -- Navegar pelos buffers
  {'<tab>', "<cmd>BufferLineCycleNext<CR>", opts},
  {'<s-tab>', "<cmd>BufferLineCyclePrev<CR>", opts},

  -- Alternar para arquivo
  {'<leader>bb', "<cmd>lua require'telescope.builtin'.buffers()<CR>", opts},

  -- Abrir arquivo
  {'<leader>pf', "<cmd>lua require'telescope.builtin'.find_files()<CR>", opts},

  -- Procurar em arquivos
  {'<leader>ps', "<cmd>lua require'telescope.builtin'.grep_string({ search = vim.fn.input('Grep For> ')})<CR>", opts},

  -- Procurar em arquivos palavra sob o cursor
  {'<leader>pe', "<cmd>lua require'telescope.builtin'.grep_string()<CR>", opts},

  -- Git log
  {'<leader>gg', "<cmd>lua require'telescope.builtin'.git_commits()<CR>", opts},

  -- Git branch
  {'<leader>gr', "<cmd>lua require'telescope.builtin'.git_branches()<CR>", opts},

  -- Git push
  {'<leader>gp', "<cmd>Git -c push.default=current push<CR>", opts},

  -- Git checkout -b
  {'<leader>gk', "<cmd>lua require'mappings'.checkout_new_branch()<CR>", opts},

  -- Colorschemes
  {'<leader>ec', "<cmd>lua require'telescope.builtin'.colorscheme()<CR>", opts},

  -- Gerencias sessões
  {
    '<leader>so',
    "<cmd>lua require'mappings'.command_with_args('Open session> ', 'default', 'customlist,xolox#session#complete_names', 'OpenSession')<CR>",
    opts
  },
  {
    '<leader>ss',
    "<cmd>lua require'mappings'.command_with_args('Save session> ', 'default', 'customlist,xolox#session#complete_names_with_suggestions', 'SaveSession')<CR>",
    opts
  },
  {'<leader>sc', "<cmd>CloseSession<CR>", opts},

  -- Git
  { '<leader>gb', '<cmd>Git blame<CR> ', opts},
  { '<leader>gc', '<cmd>Git commit<CR> ', opts},
  { '<leader>gd', '<cmd>Gdiff<CR> ', opts},
  { '<leader>gl', '<cmd>Git pull --rebase<CR> ', opts},
  { '<leader>gs', '<cmd>Git<CR> ', opts},
  { '<leader>gw', '<cmd>Gwrite<CR> ', opts},

  -- Dividir a tela mais rapidamente
  { '<leader>h', '<cmd>split<CR> ', opts},
  { '<leader>v', '<cmd>vsplit<CR> ', opts},
  { '<leader>=', '<c-w>=', opts},

  -- Abrir terminal
  { '<leader>t', '<cmd>exe v:count1 . "ToggleTerm"<CR>' , opts},

  -- Toda a vez que pular para próxima palavra buscada o cursor fica no centro da tela
  { 'n', 'nzzzv', opts },
  { 'N', 'Nzzzv', opts },

  -- Explorador de arquivos
  { '<F3>', '<cmd>NvimTreeToggle<CR>' , opts},
  { '<F2>', '<cmd>NvimTreeFindFile<CR>' , opts},

  -- Abas
  { '<leader>aa', '<cmd>tabnew<CR>' , opts},
  { '<leader>an', '<cmd>tabnext<CR>' , opts},
  { '<leader>ap', '<cmd>tabprevious<CR>' , opts},
  { '<leader>ac', '<cmd>tabclose<CR>' , opts},

  -- Selecionar todo o arquivo
  { '<leader>ba', 'ggVG', opts },

  -- Buffers
  { '<leader>bd', '<cmd>bp|bd #<CR>' , opts},
  { '<leader>bs', '<cmd>w<CR>' , opts},
  { '<leader>wc', '<cmd>q<CR>' , opts},


  -- Mover cursor para outra janela divida
  { '<C-j>', '<C-w>j', opts },
  { '<C-k>', '<C-w>k', opts },
  { '<C-l>', '<C-w>l', opts },
  { '<C-h>', '<C-w>h', opts },

  -- Limpar seleção da pesquisa
  { '<leader><leader>', '<cmd>noh<cr>' , opts},

  -- Alterar de arquivo mais rapidamente
  { '<leader><Tab>', '', opts },

  -- Limpar espaços em branco nos finais da linha
  { '<F5>', 'mp<cmd>%s/\\s\\+$/<CR>`p' , opts},

  -- Enter no modo normal funciona como no modo inserção
  { '<CR>', 'i<CR><Esc>', opts },

  -- Identar arquivo
  { '<leader>i', 'mpgg=G`p', opts },

  -- Chamar função que alterna o quickfix
  { '<leader>q', "<cmd>lua require'functions'.toggle_quickfix()<CR>" , opts},
  -- Alterar locationlist
  -- { '<leader>l', '<cmd>call LListToggle()<CR>' , opts},
  { '<leader>l', "<cmd>lua require'functions'.toggle_location_list()<CR>" , opts},

  -- Setas redimensionam janelas adjacentes
  { '<left>', '<cmd>vertical resize -5<cr>' , opts},
  { '<right>', '<cmd>vertical resize +5<cr>' , opts},
  { '<up>', '<cmd>resize -5<cr>' , opts},
  { '<down>', '<cmd>resize +5<cr>' , opts},

  -- Ponto e vírgula no final da linha
  { '<leader>;', 'mpA;<Esc>`p', opts },
  -- Vírgula no final da linha
  { '<leader>,', 'mpA,<Esc>`p', opts },

  -- Abrir configurações do vim
  { '<leader>oi', "<cmd>exe 'edit' stdpath('config').'/init.vim'<CR>" , opts},
  { '<leader>oui', "<cmd>exe 'edit' stdpath('config').'/lua/user/init.lua'<CR>" , opts},
  { '<leader>oup', "<cmd>exe 'edit' stdpath('config').'/lua/user/plugins.lua'<CR>" , opts},

  -- Abrir configurações de plugins do vim
  { '<leader>op', "<cmd>exe 'edit' stdpath('config').'/lua/plugins.lua'<CR>" , opts},

  -- Atualizar configurações do nvim
  { '<leader>os', "<cmd>exe 'source' stdpath('config').'/init.lua'<CR>" , opts},

  -- Pular para a próxima função do Elm
  { ']]', "<cmd>call search('^\\w\\+\\s:\\s', 'w')<CR>" , opts},
  { '[[', "<cmd>call search('^\\w\\+\\s:\\s', 'bW')<CR>" , opts},

  -- Whichkey
  { '<leader>', "<cmd>WhichKey '<space>'<CR>", opts },
  { '<localleader>', "<cmd>WhichKey '\\'<CR>", opts },
}

local terminal = {
  -- Ir para modo normal no terminal de forma rapida
  {'jk', '<c-\\><c-n>', opts},
  {'kj', '<C-\\><C-n>', opts}
}

local visual = {
  {'<', '<gv', opts},
  {'>', '>gv', opts},
  { '//', 'y/<C-R>"<CR>', opts },
  {'K', ":m '<-2<CR>gv=gv", opts},
  {'J', ":m '>+1<CR>gv=gv", opts},
}

local function setup()
  set_keymaps('t', terminal)
  set_keymaps('i', insert)
  set_keymaps('c', command)
  set_keymaps('n', normal)
  set_keymaps('v', visual)
end

local function lsp(client)
  -- buf_set_keymap('n', '<leader>ca', "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap('n', '<leader>ca', "<cmd>lua require'telescope.builtin'.lsp_code_actions(require('telescope.themes').get_dropdown({}))<CR>", opts)
  buf_set_keymap('n', '<leader>co', "<cmd>lua require'telescope.builtin'.lsp_document_symbols()<CR>", opts)
  buf_set_keymap('n', '<leader>cp', "<cmd>lua require'telescope.builtin'.lsp_dynamic_workspace_symbols()<CR>", opts)
  buf_set_keymap('n', 'gd', "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap('n', '<leader>cs', "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap('n', 'gy', "<cmd>lua require'telescope.builtin'.lsp_type_definitions()<CR>", opts)
  buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', "<cmd>lua require'telescope.builtin'.lsp_references()<CR>", opts)
  buf_set_keymap('n', '<leader>ce', "<cmd>lua vim.diagnostic.open_float(0, { scope = 'line', border = 'single' })<CR>", opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next({ float =  { show_header = true, border = "single" }})<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ float =  { show_header = true, border = "single" }})<CR>', opts)
  buf_set_keymap('n', ']e', "<cmd>lua vim.diagnostic.goto_next({ float =  { show_header = true, border = 'single' }, severity = 'Error' })<CR>", opts)
  buf_set_keymap('n', '[e', "<cmd>lua vim.diagnostic.goto_prev({ float =  { show_header = true, border = 'single' }, severity = 'Error' })<CR>", opts)
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
  command_with_args = command_with_args,
}

setup()

return M
