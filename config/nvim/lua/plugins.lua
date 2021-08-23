-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd matchit]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Sessões
  use {
      'xolox/vim-session',
      requires = { 'xolox/vim-misc' },
      opt = true,
      cmd = {'SaveSession', 'OpenSession', 'DeleteSession', 'CloseSession'}
  }

  -- Buscador
  use { 'junegunn/fzf' }
  use { 'junegunn/fzf.vim', requires = { 'junegunn/fzf' } }

  -- Comandos de LSP com fzf
  use {
      'ojroques/nvim-lspfuzzy',
      requires = {
          {'junegunn/fzf'},
          {'junegunn/fzf.vim'},  -- to enable preview (optional)
      },
  }
  -- Sintasse para várias linguagens
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }

  -- Exibe espaços vazios no final da linha
  use 'bronson/vim-trailing-whitespace'

  -- Adicionar comentários com 'gcc'
  use 'tpope/vim-commentary'

  -- Habilita o uso do emmet (<C-y>,)
  use 'mattn/emmet-vim'

  -- Habilita a busca rapida usando duas letras
  use 'ggandor/lightspeed.nvim'

  -- Tema gruvbox
  use {"ellisonleao/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}


  -- Mostra um git diff na coluna de número e comandos para hunks
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }

  -- Mostra linhas de indentação
  use "lukas-reineke/indent-blankline.nvim"

  -- Auto-fechamento de delimitadores
  use 'cohama/lexima.vim'

  -- Operação com delimitadores
  use 'tpope/vim-surround'

  -- Se mover melhor com o f/t
  use 'unblevable/quick-scope'

  -- Text-objects melhorados e com seek
  use 'wellle/targets.vim'

  -- Explorador de arquivos
  use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      opt = true,
      cmd = {'NvimTreeToggle', 'NvimTreeFindFile'}
  }
  -- Warper para comandos do git
  use {
      'tpope/vim-fugitive',
      opt = true,
      cmd = {'Git', 'Gdiff', 'Gclog', 'Gwrite'}
  }

  -- Engine de snippets
  use 'SirVer/ultisnips'

  -- Biblioteca de snippets
  use 'honza/vim-snippets'

  -- Status line
  use {
      'glepnir/galaxyline.nvim',
      branch = 'main',
      -- your statusline
      config = function() require'eviline' end,
      -- some optional icons
      requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- Guia de atalhos
  use 'liuchengxu/vim-which-key'

  -- Cliente REST
  use 'diepm/vim-rest-console'

  -- LSP do Nvim
  use 'neovim/nvim-lspconfig'

  -- Autocompletion framework for built-in LSP
  use 'hrsh7th/nvim-compe'

  -- TabNine
  use {'tzachar/compe-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-compe'}
  --
  -- Plugin LSP com base no cliente lsp do neovim
  use { 'glepnir/lspsaga.nvim', requires = {'neovim/nvim-lspconfig'} }

  -- Assinaturas de funções ao digitar
  use 'ray-x/lsp_signature.nvim'

  -- Ícones
  -- use 'ryanoasis/vim-devicons'
  use 'kyazdani42/nvim-web-devicons'

  -- Informações de LSP na statusline
  use 'nvim-lua/lsp-status.nvim'

  -- Ícones no completion
  use 'onsails/lspkind-nvim'

  -- Alternador de terminal
  use 'akinsho/nvim-toggleterm.lua'

  -- Lista de diagnostics
  use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
          require("trouble").setup {
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
          }
      end
  }

  -- Mostrar o que há nos registradores
  use 'tversteeg/registers.nvim'

  -- Buffers no topo
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
end)
