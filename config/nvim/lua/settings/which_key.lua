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
    f = 'Formatar código',
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
    y = 'Abrir lazygit',
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
  t = {
    f = 'Abrir terminal flutuante',
    n = 'Próximo (next) terminal',
    o = 'Abrir terminal',
    p = 'Terminal anterior (previous)',
    t = 'Esconder/mostrar terminal atual',
  },
  v = 'Dividir verticalmente',
  w = {
    name = '+Window/Wiki',
    c = 'Fechar janela',
  }
}

vim.fn['which_key#register']('<Space>', 'g:which_key_map')
