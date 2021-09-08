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
"" Encoding
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set binary

" Comportamento do Tab
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

" Busca
set ignorecase
set smartcase
if has('nvim')
    set inccommand=split
endif

" Configurações do Swap file
set nobackup
set noswapfile
set nowritebackup

set fileformats=unix,dos,mac

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

" Exibição de caracteres especiais
set listchars=tab:↦\ ,nbsp:␣

" Gerenciamento de sessão
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

" Opções para o vim-rest-console
let g:vrc_curl_opts = {
            \ '-sS': '',
            \ '--connect-timeout': 10,
            \ '-i': '',
            \ '--max-time': 60,
            \ '-k': '',
            \}

" Formatar resposta em JSON
let g:vrc_auto_format_response_patterns = {
            \ 'json': 'python3 -m json.tool',
            \ }

" Permitir que parâmetros GET sejam declarados em linhas sequenciais
let g:vrc_split_request_body = 0

" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__

" Configuração de leader
let mapleader="\<Space>"

" Configuração de local leader
let maplocalleader="\\"

" Habilitar itablico do gruvbox
let g:gruvbox_italic = 1

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

" Tema do gruvbox
colorscheme gruvbox

" Sobrescrevendo cor do quick-scope porque ela some no tema do vscode
highlight QuickScopePrimary guifg='#7a7608'
highlight QuickScopeSecondary guifg='#e27bed'

" Realçar linha onde o cursor está
set cursorline

" Melhora as cores, se tiver suporte
if (has("termguicolors"))
    set termguicolors
endif

" Usar o emmet apenas no modo visual ou no modo inserção
let g:user_emmet_mode='iv'

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

" Fold com treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
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

" Identação no javascript
augroup vimrc-javascript
    autocmd!
    autocmd FileType javascript set tabstop=2|set shiftwidth=2|set expandtab softtabstop=2
    autocmd FileType typescript set tabstop=2|set shiftwidth=2|set expandtab softtabstop=2
    autocmd FileType typescriptreact set tabstop=2|set shiftwidth=2|set expandtab softtabstop=2
augroup END

" Identação no Dart
augroup vimrc-dart
    autocmd!
    autocmd FileType dart set tabstop=2|set shiftwidth=2|set expandtab softtabstop=2
augroup END

" Corrigir sintaxe nos arquivos .vue
augroup vue-syntax
    autocmd!
    autocmd FileType vue syntax sync fromstart
augroup END

" Configuração de comentário para twig
augroup twig-comment
    autocmd!
    autocmd FileType html.twig setlocal commentstring={#\ %s\ #}
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

" Use <c-space> for trigger completion.
" inoremap <silent><expr> <C-Space> compe#complete()
" inoremap <silent><expr> <C-y> compe#confirm()
" inoremap <silent><expr> <C-e> compe#close('<C-e>')
" inoremap <silent><expr> <CR> lexima#expand('<LT>CR>', 'i')

" Gerencias sessões
nnoremap <leader>so :OpenSession<Space>
nnoremap <leader>ss :SaveSession<Space>
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>

" Git
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gl :Git pull<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gw :Gwrite<CR>

" Dividir a tela mais rapidamente
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

" Abrir terminal
nnoremap <silent><leader>t :<c-u>exe v:count1 . "ToggleTerm"<CR>

" Toda a vez que pular para próxima palavra buscada o cursor fica no centro da tela
nnoremap n nzzzv
nnoremap N Nzzzv

" Explorador de arquivos
nnoremap <F3> :NvimTreeToggle<CR>
nnoremap <F2> :NvimTreeFindFile<CR>

" Ir para o normal mode mais rapidamente
imap jk <Esc>
imap kj <Esc>

" Abrir uma nova aba
nnoremap <leader>aa :tabnew<CR>

" Ir para a aba seguinte
nnoremap <leader>an :tabnext<CR>

" Ir para a aba anterior
nnoremap <leader>ap :tabprevious<CR>

" Fechar a aba
nnoremap <leader>ac :tabclose<CR>

" Selecionar todo o arquivo
nnoremap <leader>ba ggVG

" Fechar buffer atual
noremap <leader>bd :bp\|bd #<CR>

" Salvar buffer
nnoremap <leader>bs :w<CR>

" Fechar janela
nnoremap <leader>wc :q<CR>

" Mover bloco de código selecionado
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Manter seleção após indentar código no modo visual
vmap < <gv
vmap > >gv

" Mover cursor para outra janela divida
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

" Limpar seleção da pesquisa
nnoremap <silent> <leader><leader> :noh<cr>

" Alterar de arquivo mais rapidamente
nnoremap <silent> <leader><Tab> 

" Limpar espaços em branco nos finais da linha
nnoremap <F5> mp:%s/\s\+$/<CR>`p

" Buscar o que está visualmente selecionado pressionando //
vnoremap // y/<C-R>"<CR>

" Enter no modo normal funciona como no modo inserção
nnoremap <CR> i<CR><Esc>

" Identar arquivo
nnoremap <leader>i mpgg=G`p

" Chamar função que alterna o quickfix
nnoremap <leader>q :call QFixToggle()<CR>

" Setas redimensionam janelas adjacentes
nnoremap <left> :vertical resize -5<cr>
nnoremap <right> :vertical resize +5<cr>
nnoremap <up> :resize -5<cr>
nnoremap <down> :resize +5<cr>

" Ponto e vírgula no final da linha
noremap <leader>; mpA;<Esc>`p

" Vírgula no final da linha
noremap <leader>, mpA,<Esc>`p

" Abrir configurações do vim
nnoremap <leader>ov :exe 'edit' stdpath('config').'/init.vim'<CR>

" Abrir configurações do vim personalizadas
nnoremap <leader>om :exe 'edit' stdpath('config').'/myinit.vim'<CR>

" Abrir configurações de plugins do vim
nnoremap <leader>op :exe 'edit' stdpath('config').'/lua/plugins.lua'<CR>

" Abrir configurações de plugins do vim
nnoremap <leader>ou :exe 'edit' stdpath('config').'/myinit.bundles.vim'<CR>

" Atualizar configurações do nvim
nnoremap <leader>os :exe 'source' stdpath('config').'/init.vim'<CR>

" Alterar locationlist
nnoremap <leader>l :call LListToggle()<CR>

" Mapeamento para listas
" Abrir lista
" nnoremap <leader>lo :vert botright 45split ~/vimwiki/index.wiki<CR>

" Inserir data de hoje
" nnoremap <leader>ldn :r !date +\%d/\%b/\%Y\(\%Y\-\%m\-\%d\)\ \(\%A\)<CR>

" Inserir data de amanhã
" nnoremap <leader>ldt :r !date +\%d/\%b/\%Y\(\%Y\-\%m\-\%d\)\ \(\%A\) --date='tomorrow'<CR>

" Pular para a próxima função do Elm
nnoremap ]] :call search('^\w\+\s:\s', 'w')<CR>
nnoremap [[ :call search('^\w\+\s:\s', 'bW')<CR>

"*****************************************************************************
"" Source do arquivo do usuário
"*****************************************************************************

" Arquivo de configurações do usuário
let s:user_file = stdpath('config') . '/myinit.vim'
if filereadable(s:user_file)
    exec "source" s:user_file
endif
