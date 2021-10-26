-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd matchit]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require'packer'.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  --
  -- Ícones
  use 'kyazdani42/nvim-web-devicons'

  -- Editorconfig
  use 'editorconfig/editorconfig-vim'

  -- Sessões
  use 'xolox/vim-misc'
  use {
    'xolox/vim-session',
    requires = { 'xolox/vim-misc' },
    -- opt = true,
    -- cmd = {'SaveSession', 'OpenSession', 'DeleteSession', 'CloseSession'}
  }

  -- Buscador
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require'telescope'.setup {
        defaults = {
          mappings = {
            i = {
              ['<c-j>'] = require'telescope.actions'.move_selection_next,
              ['<c-k>'] = require'telescope.actions'.move_selection_previous,
              ['<esc>'] = require'telescope.actions'.close,
            }
          }
        }
      }
    end
  }

  -- Sintasse para várias linguagens
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function ()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        highlight = {
          enable = true,              -- false will disable the whole extension
        },
      }
    end
  }

  -- Exibe espaços vazios no final da linha
  use 'bronson/vim-trailing-whitespace'

  -- Adicionar comentários com 'gcc'
  -- use {
  --   'tpope/vim-commentary',
  --   opt = true,
  --   keys = 'gc',
  -- }
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  -- Habilita o uso do emmet (<C-y>,)
  use {
    'mattn/emmet-vim',
    config = function ()
      -- Usar o emmet apenas no modo visual ou no modo inserção
      vim.g.user_emmet_mode = 'iv'
      vim.g.user_emmet_leader_key = '<C-g>'
    end,
  }

  -- Habilita a busca rapida usando duas letras
  use {
    'ggandor/lightspeed.nvim',
    config = function ()
      require'lightspeed'.setup {
        jump_to_first_match = true,
        jump_on_partial_input_safety_timeout = 400,
        highlight_unique_chars = false,
        grey_out_search_area = true,
        match_only_the_start_of_same_char_seqs = true,
        limit_ft_matches = 5,
        full_inclusive_prefix_key = '<c-x>',
      }
      for _, key in ipairs {'f', 'F', 't', 'T'} do
        vim.api.nvim_del_keymap('o', key)
        vim.api.nvim_del_keymap('x', key)
        vim.api.nvim_del_keymap('n', key)
      end
    end,
  }

  -- Temas
  use 'morhetz/gruvbox'
  use 'Th3Whit3Wolf/one-nvim'
  use 'dracula/vim'
  use 'ishan9299/nvim-solarized-lua'
  use 'tomasr/molokai'
  use 'arcticicestudio/nord-vim'
  use 'NLKNguyen/papercolor-theme'
  use 'sainnhe/sonokai'
  use 'cocopon/iceberg.vim'
  use 'drewtempelmeyer/palenight.vim'
  use 'flrnd/plastic.vim'
  use 'projekt0n/github-nvim-theme'
  use 'hzchirs/vim-material'
  use 'jsit/toast.vim'
  use 'Th3Whit3Wolf/space-nvim'
  use 'rafamadriz/neon'
  use 'Pocco81/Catppuccino.nvim'
  use 'folke/tokyonight.nvim'
  use 'sainnhe/edge'
  use 'junegunn/seoul256.vim'


  -- Mostra um git diff na coluna de número e comandos para hunks
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require'gitsigns'.setup {
        numhl = false,
        linehl = false,
        keymaps = {
          -- Default keymap options
          noremap = true,
          buffer = true,

          ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
          ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

          ['n <leader>ghu'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          ['v <leader>ghu'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
          ['n <leader>ghv'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',

          -- Text objects
          -- ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
          -- ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
        },
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 0
        }
      }
    end
  }

  -- Mostra linhas de indentação
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function ()
      require'indent_blankline'.setup{
        show_current_context = true
      }
    end
  }

  -- Auto-fechamento de delimitadores
  use {
    'windwp/nvim-autopairs',
    config = function()
      require'nvim-autopairs'.setup()
    end
  }

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
    config = function ()
      require'nvim-tree'.setup{}
    end
  }

  -- Warper para comandos do git
  use {
    'tpope/vim-fugitive',
    opt = true,
    cmd = {'G', 'Git', 'Gdiff', 'Gclog', 'Gwrite'}
  }

  -- Engine de snippets
  -- use 'SirVer/ultisnips'
  use 'L3MON4D3/LuaSnip'

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
  use {
    'diepm/vim-rest-console',
    opt = true,
    ft = 'rest',
  }

  -- LSP do Nvim
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'

  -- Autocompletion framework for built-in LSP
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      -- "hrsh7th/vim-vsnip",
      -- "quangnguyen30192/cmp-nvim-ultisnips",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
    },
    config = function ()
      local cmp = require'cmp'
      local lspkind = require'lspkind'

      cmp.setup({
        snippet = {
          expand = function(args)
            -- vim.fn["UltiSnips#Anon"](args.body)
            require'luasnip'.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind] .. " " .. vim_item.kind
            vim_item.menu = ({
              path = "[Path]",
              buffer = "[Buffer]",
              calc = "[Calc]",
              nvim_lsp = "[LSP]",
              cmp_tabnine = "[TabNine]",
              ultisnips = "[UltiSnips]",
              emoji = "[Emoji]",
            })[entry.source.name]
            return vim_item
          end
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'cmp_tabnine' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
          { name = 'calc' },
          -- { name = 'ultisnips' },
          { name = 'emoji' },
        },
        experimental = {
          native_menu = false,
          ghost_text = true
        }
      })

      require'nvim-autopairs.completion.cmp'.setup{
        map_complete = false
      }
    end,
  }

  -- TabNine
  use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}

  -- Assinaturas de funções ao digitar
  use {
    'ray-x/lsp_signature.nvim',
    config = function ()
      require'lsp_signature'.setup()
    end
  }


  -- Informações de LSP na statusline
  use {
    'nvim-lua/lsp-status.nvim',
    config = function ()
      require'lsp-status'.register_progress()
    end
  }

  -- Ícones no completion
  use {
    'onsails/lspkind-nvim',
    config = function ()
      require'lspkind'.init()
    end
  }

  -- Alternador de terminal
  use {
    'akinsho/nvim-toggleterm.lua',
    config = function ()
      require'toggleterm'.setup{
        open_mapping = [[<c-\>]],
        shade_terminals = false,
        direction = 'horizontal'
      }
    end,
    opt = true,
    cmd = 'ToggleTerm',
  }

  -- Lista de diagnostics
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require'trouble'.setup {
        auto_preview = false,
        signs = {
          -- icons / text used for a diagnostic
          error = " - Err - ",
          warning = " - War - ",
          hint = " - Hin - ",
          information = " - Inf - "
        },
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
    opt = true,
    cmd = 'Trouble',
  }

  -- Mostrar o que há nos registradores
  use 'tversteeg/registers.nvim'

  -- Buffers no topo
  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require'bufferline'.setup()
    end
  }

  -- Mostrar lampada se existir code action
  use {
    'kosayoda/nvim-lightbulb',
    config = function()
      vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
    end
  }

  local user_file = vim.fn.stdpath('config') .. '/lua/user/plugins.lua'
  if vim.fn.filereadable(user_file) > 0 then
    require'user.plugins'.setup(use)
  end
end)
