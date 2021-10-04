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
