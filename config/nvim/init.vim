"*****************************************************************************
"" Configuração do Packer
"*****************************************************************************
let packer_exists=expand('~/.local/share/nvim/site/pack/packer/start/packer.nvim/lua/packer.lua')

if !filereadable(packer_exists)
  if !executable("git")
    echoerr "You have to install git or first install packer yourself!"
    execute "q!"
  endif
  echo "Installing Packer..."
  echo ""
  !\git clone https://github.com/wbthomason/packer.nvim "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/packer/start/packer.nvim

  autocmd VimEnter * PackerInstall
endif

" Arquivo de plugins do usuário
" let s:bundles_user_file = stdpath('config') . '/myinit.bundles.vim'
" if filereadable(s:bundles_user_file)
"     exec "source" s:bundles_user_file
" endif

lua require('plugins')

"*****************************************************************************
"" Configurações básicas
"*****************************************************************************"

" Permitir que parâmetros GET sejam declarados em linhas sequenciais
let g:vrc_split_request_body = 0

" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__

" Configuração de leader
let mapleader="\<Space>"

" Configuração de local leader
let maplocalleader="\\"

" Desabilitar editorconfig para fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Desabilitar preprocessadores para deixar arquivos .vue mais rapidos
let g:vue_disable_pre_processors=1

" Ao abrir o tagbar atribuir o foco à ele
let g:tagbar_autofocus = 1

" The system menu file includes a "Buffers" menu.  If you don't want this, set the 'no_buffers_menu'
let no_buffers_menu=1

" Idioma para correção ortográfica
set spelllang=pt

" Enable hidden buffers
set hidden

" Disable the blinking cursor.
set gcr+=a:blinkon0

" Número mínimo de linha que deverão ser mostradas antes e depois do cursor
set scrolloff=5

" Copy/Paste/Cut from clipboard
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

" Ao clicar clicar com shift + botão direito do mouse, abre-se um menu
set mousemodel=popup

" Suporte ao mouse
set mouse=a

" Mostra os números da linha de forma relativa e o número atual da linha
set number relativenumber

" Configuração do which-key
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :WhichKey '\\'<CR>

" Dicionário do which-key
let g:which_key_map = {}
let g:which_key_map[','] = '"," no fim da linha'
let g:which_key_map[';'] = '";" no fim da linha'
let g:which_key_map['<Tab>'] = 'Alterar para arquivo anterior'
let g:which_key_map.a = {
      \ 'name' : '+Aba',
      \ 'a' : 'Abrir uma nova',
      \ 'n' : 'Ir para a próxima (next)',
      \ 'p' : 'Ir para a anterior (previous)',
      \ 'c' : 'Fechar (close)',
      \ }
let g:which_key_map.b = {
      \ 'name' : '+Buffer',
      \ 'b' : 'Listar abertos',
      \ 'd' : 'Deletar',
      \ 's' : 'Salvar',
      \ 'a' : 'Selecionar tudo (all)',
      \ }
let g:which_key_map.c = {
      \ 'name' : '+Code',
      \ 'a' : 'Ações',
      \ 'd' : 'Ver definição',
      \ 'e' : 'Mostrar erro da linha',
      \ 'o' : 'Buscar símbolos',
      \ 'r' : 'Renomear Variável',
      \ 's' : 'Assinatura',
      \ }
" let g:which_key_map.d = {
  "             \ 'name' : '+Debug',
  "             \ 'b' : 'Adicionar breakpoint',
  "             \ 'r' : 'Executar (run) o modo debug',
  "             \ 's' : 'Parar (stop) o modo debug',
  "             \ }
  let g:which_key_map.g = {
        \ 'name' : '+Git',
        \ 'b' : 'Blame',
        \ 'c' : 'Commit',
        \ 'g' : 'Log',
        \ 'h' : {
          \   'name': '+Hunks',
          \   'n': 'Próximo (next)',
          \   'p': 'Anterior (previous)',
          \   'u': 'Desfazer (undo)',
          \   'v': 'Ver',
          \ },
          \ 'l' : 'Pull',
          \ 'p' : 'Push',
          \ 's' : 'Status',
          \ 'w' : 'Salvar e adicionar ao stage',
          \ }
  let g:which_key_map.h = 'dividir-tela-horizontalmente'
  let g:which_key_map.i = 'indentar-arquivo'
  let g:which_key_map.l = 'alternar-locationlist'
  let g:which_key_map.o = {
        \ 'name' : '+Abrir arquivos do vim',
        \ 'v' : 'Abrir .vimrc',
        \ 'b' : 'Abrir .vimrc.bundles',
        \ 'm' : 'Abrir .myvimrc',
        \ 'u' : 'Abrir .myvimrc.bundles',
        \ 's' : 'Atualizar (source) configurações do vim',
        \ }
  let g:which_key_map.p = {
        \ 'name' : '+Projeto',
        \ 'e' : 'Procurar texto sob cursor',
        \ 'f' : 'Buscar (find) arquivo',
        \ 's' : 'Procurar (search) nos arquivos',
        \ }
  let g:which_key_map.q = 'alternar-quickfix'
  let g:which_key_map.s = {
        \ 'name' : '+Sessão',
        \ 'c' : 'Fechar (close)',
        \ 'd' : 'Deletar',
        \ 'o' : 'Abrir',
        \ 's' : 'Salvar',
        \ }
  let g:which_key_map.t = 'Abrir terminal (suporte a count)'
  let g:which_key_map.v = 'dividir-tela-verticalmente'
  let g:which_key_map.w = {
        \ 'name' : '+Window/Wiki',
        \ 'c' : 'Fechar janela',
        \ }

  " Diminuir o tempo para mostrar o which-key (Default: 1000)
  set timeoutlen=500

  " Sobrescrevendo cor do quick-scope porque ela some no tema do vscode
  highlight QuickScopePrimary guifg='#7a7608'
  highlight QuickScopeSecondary guifg='#e27bed'

  " Realçar linha onde o cursor está
  set cursorline

  " Melhora as cores, se tiver suporte
  if (has("termguicolors"))
    set termguicolors
  endif

  " Pasta para snippets
  let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

  " Não redimensionar janelas abertas ao abrir ou fechar janelas
  set noequalalways

  " Espaço maior para mensagens
  set cmdheight=2

  " Diminuir tempo de atualização
  set updatetime=300

  " Não passar as mensagems para o |ins-completion-menu|
  set shortmess+=c

  " Deixar a coluna de sinais sempre aberta
  set signcolumn=yes

  " Autocomplete melhor
  set completeopt=menuone,noselect

  " Configurar o lexima com o compe
  let g:lexima_no_default_rules = v:true
  call lexima#set_default_rules()

  lua require('settings')

  " Fold com treesitter
  " set foldmethod=expr
  " set foldexpr=nvim_treesitter#foldexpr()
  "*****************************************************************************
  "" Comandos
  "*****************************************************************************

  " Fechar todos os outros buffers
  command! Bdall %bd|e#|bd#

  " Cor de fundo transparente
  command! Transparent hi Normal guibg=NONE ctermbg=NONE

  "*****************************************************************************
  "" Configurações visuais
  "*****************************************************************************

  set t_Co=256
  set guioptions=egmrti

  let g:CSApprox_loaded = 1
  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color
  else
    if $TERM == 'xterm' && has('vim')
      set term=xterm-256color
    endif
  endif

  if &term =~ '256color'
    set t_ut=
  endif

  "*****************************************************************************
  "" Funções
  "*****************************************************************************
  if !exists('*s:setupWrapping')
    function s:setupWrapping()
      set wrap
      set wm=2
      set textwidth=79
    endfunction
  endif

  " Função para alterar o quickfix
  function! QFixToggle()
    if exists("g:qfix_win")
      cclose
      unlet g:qfix_win
    else
      botright copen 10
      let g:qfix_win = bufnr("$")
    endif
  endfunction

  " Função para alterar o quickfix
  function! LListToggle()
    if exists("g:llist_win")
      lclose
      unlet g:llist_win
    else
      lopen 10
      let g:llist_win = bufnr("$")
    endif
  endfunction

  "*****************************************************************************
  "" Comandos automáticos
  "*****************************************************************************

  " Guardar posição do cursor
  augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  augroup END

  " Corrigir sintaxe nos arquivos .vue
  augroup vue-syntax
    autocmd!
    autocmd FileType vue syntax sync fromstart
  augroup END

  " Sempre que entrar na janela de quickfix retirar o mapeamento customizado do Enter
  augroup enable-cr-quickfix
    " In the quickfix window, <CR> is used to jump to the error under the cursor, so undefine the mapping there.
    autocmd!
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
  augroup END

  " Abrir todos os foldings quando entrar em um arquivo
  augroup openfold
    autocmd!
    autocmd BufEnter,FocusGained * norm zR
  augroup END

  " Ativa o número da linha relativo apenas quando o buffer estiver em foco e no normal mode
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  augroup END

  augroup LuaHighlight
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
  augroup END

  " Formata o arquivo ao salvar
  augroup format-on-save
    autocmd!
    autocmd BufWrite * silent! lua vim.lsp.buf.formatting_sync(nil, 1000)
  augroup END

  " Reconhecer .exs como elixir
  augroup exs-filetype
    autocmd!
    autocmd BufRead,BufNewFile *.exs		set filetype=elixir
  augroup END


  "*****************************************************************************
  "" Mapeamentos
  "*****************************************************************************

  lua require('config')

  " Abrir configurações do vim personalizadas
  " nnoremap <leader>om :exe 'edit' stdpath('config').'/myinit.vim'<CR>

  " Abrir configurações de plugins do vim
  " nnoremap <leader>ou :exe 'edit' stdpath('config').'/myinit.bundles.vim'<CR>

  "*****************************************************************************
  "" Source do arquivo do usuário
  "*****************************************************************************

  " Arquivo de configurações do usuário
  let s:user_file = stdpath('config') . '/lua/user/init.lua'
  if filereadable(s:user_file)
    lua require('user')
  endif
