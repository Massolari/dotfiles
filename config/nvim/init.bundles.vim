" Sessões
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

" Buscador de arquivos na pasta atual
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif

" Sintasse para várias linguagens
" Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" Exibe espaços vazios no final da linha
Plug 'bronson/vim-trailing-whitespace'

" Adicionar comentários com 'gcc'
Plug 'tpope/vim-commentary'

" Habilita o uso do emmet (<C-y>,)
Plug 'mattn/emmet-vim'

" Tema gruvbox
Plug 'morhetz/gruvbox'

" Habilita a busca rapida usando duas letras
" Plug 'justinmk/vim-sneak'
Plug 'ggandor/lightspeed.nvim'

" Mostra um git diff na coluna de número
Plug 'airblade/vim-gitgutter'

" Mostra linhas de indentação
Plug 'Yggdroot/indentLine'

" Auto-fechamento de delimitadores
Plug 'cohama/lexima.vim'

" Operação com delimitadores
Plug 'tpope/vim-surround'

" Autocomplete
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Habilita o uso do % em tags HTML/XML, if/else entre outros blocos
if !has('nvim')
    packadd! matchit
endif

" Se mover melhor com o f/t
Plug 'unblevable/quick-scope'

" Text-objects melhorados e com seek
Plug 'wellle/targets.vim'

" Explorador de arquivos
Plug 'scrooloose/nerdtree'

" Warper para comandos do git
Plug 'tpope/vim-fugitive'

" Engine de snippets
Plug 'SirVer/ultisnips'

" Biblioteca de snippets
Plug 'honza/vim-snippets'

" Editorconfig
Plug 'editorconfig/editorconfig-vim'

" Executar script em tempo real
Plug 'metakirby5/codi.vim'

" Status bar
" Plug 'itchyny/lightline.vim'
Plug 'datwaft/bubbly.nvim'

" Guia de atalhos
Plug 'liuchengxu/vim-which-key'

" Cliente REST
Plug 'diepm/vim-rest-console'

" LSP do Nvim
Plug 'neovim/nvim-lspconfig'


" Autocompletion framework for built-in LSP
Plug 'hrsh7th/nvim-compe'
" Plug 'nvim-lua/completion-nvim'

" TabNine
" Plug 'aca/completion-tabnine', { 'do': './install.sh' }
Plug 'tzachar/compe-tabnine', { 'do': './install.sh' }

" Plugin LSP com base no cliente lsp do neovim
Plug 'glepnir/lspsaga.nvim'

" Ícones
Plug 'ryanoasis/vim-devicons'

" Informações de LSP na statusline
Plug 'nvim-lua/lsp-status.nvim'

" Comandos de LSP com fzf
Plug 'gfanto/fzf-lsp.nvim'

" Ícones no completion
Plug 'onsails/lspkind-nvim'

" Alternador de terminal
Plug 'akinsho/nvim-toggleterm.lua'

" Palenight
Plug 'drewtempelmeyer/palenight.vim'

" Lista de diagnostics
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/lsp-trouble.nvim'

" Gerenciador de tarefas
Plug 'dhruvasagar/vim-dotoo'
