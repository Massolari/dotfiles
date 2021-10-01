-- Encoding
vim.opt.fileencoding = 'utf-8'
vim.opt.fileformats = { 'unix','dos','mac' }

-- Comportamento do Tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Busca
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

-- Arquivo swap
vim.opt.swapfile = false

local envShell = os.getenv('SHELL')
if envShell ~= "" then
  vim.opt.shell = envShell
else
  vim.opt.shell = '/bin/sh'
end

-- Gerenciamento de sessão
vim.g.session_directory = "~/.vim/session"
vim.g.session_autoload = "no"
vim.g.session_autosave = "no"
vim.g.session_command_aliases = 1

-- Opções para o vim-rest-console
vim.g.vrc_curl_opts = {
  ['-sS'] = '',
  ['--connect-timeout'] = 10,
  ['-i'] = '',
  ['--max-time'] = 60,
  ['-k'] = '',
}

-- -- Formatar resposta em JSON
vim.g.vrc_auto_format_response_patterns = {
  json = 'python3 -m json.tool',
}

-- Which-key
vim.g.which_key_map = {
  [','] = '"," no fim da linha',
  [';'] = '";" no fim da linha',
  ['<Tab>'] = 'Alterar para arquivo anterior',
  ['='] = 'Igualar tamanho das janelas',
  a = {
    name = '+Aba',
    a = 'Abrir uma nova',
    n = 'Ir para a próxima (next)',
    p = 'Ir para a anterior (previous)',
    c = 'Fechar (close)',
  },
  b = {
    name = '+Buffer',
    b = 'Listar abertos',
    d = 'Deletar',
    s = 'Salvar',
    a = 'Selecionar tudo (all)',
  },
  c = {
    name = '+Code',
    a = 'Ações',
    d = 'Problemas (diagnostics)',
    e = 'Mostrar erro da linha',
    o = 'Buscar símbolos no arquivo',
    p = 'Buscar símbolos no projeto',
    r = 'Renomear Variável',
    s = 'Assinatura',
  },
  e = {
    name = '+Editor',
    c = 'Temas (colorscheme)'
  },
  g = {
    name = '+Git',
    b = 'Blame',
    c = 'Commit',
    d = 'Diff',
    g = 'Log',
    h = {
      name= '+Hunks',
      n= 'Próximo (next)',
      p= 'Anterior (previous)',
      u= 'Desfazer (undo)',
      v= 'Ver',
    },
    k = 'Criar branch e fazer checkout',
    l = 'Pull',
    p = 'Push',
    r = 'Listar branches',
    s = 'Status',
    w = 'Salvar e adicionar ao stage',
  },
  h = 'Dividir horizontalmente',
  i = 'Indentar arquivo',
  l = 'Alternar locationlist',
  o = {
    name = '+Abrir arquivos do vim',
    i = 'init.vim',
    p = 'plugins.lua',
    u = {
      name = 'Arquivos do usuário',
      i = 'init.lua do usuário',
      p = 'plugins.lua do usuário',
    },
    s = 'Atualizar (source) configurações do vim',
  },
  p = {
    name = '+Projeto',
    e = 'Procurar texto sob cursor',
    f = 'Buscar (find) arquivo',
    s = 'Procurar (search) nos arquivos',
  },
  q = 'Alternar quickfix',
  s = {
    name = '+Sessão',
    c = 'Fechar (close)',
    d = 'Deletar',
    o = 'Abrir',
    s = 'Salvar',
  },
  t = 'Abrir terminal (suporte a count)',
  v = 'Dividir verticalmente',
  w = {
    name = '+Window/Wiki',
    c = 'Fechar janela',
  }
}


-- Tema
vim.opt.background = 'light'

-- -- Gruvbox
vim.g.gruvbox_italic = 1

-- -- Material
vim.g.material_style = 'lighter'

-- -- Neon
vim.g.neon_style = 'light'
vim.g.neon_bold = true

-- -- Tokyonight
vim.g.tokyonight_style = 'day'

vim.cmd('colorscheme one-nvim')

