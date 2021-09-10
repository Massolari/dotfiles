-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd matchit]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require('packer').startup(function(use)
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
      opt = true,
      cmd = {'SaveSession', 'OpenSession', 'DeleteSession', 'CloseSession'}
  }

  -- Buscador
  use { 'junegunn/fzf', run = './install --bin', }
  use {
      'ibhagwan/fzf-lua',
      requires = {
          'vijaymarupudi/nvim-fzf',
          'kyazdani42/nvim-web-devicons'
      },
      config = function ()
          require'fzf-lua'.setup({ fzf_layout = 'default' })
      end
  }
  -- use {
  --     'junegunn/fzf.vim',
  --     requires = { 'junegunn/fzf' },
  --     opt = true,
  --     cmd = { 'Files', 'Buffers', 'Rg' }
  -- }

  -- Comandos de LSP com fzf
  -- use {
  --     'ojroques/nvim-lspfuzzy',
  --     requires = {
  --         {'junegunn/fzf'},
  --         {'junegunn/fzf.vim'},
  --     },
  --     config = function ()
  --         require'lspfuzzy'.setup{}
  --     end
  -- }
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
  use {
      'tpope/vim-commentary',
      opt = true,
      keys = 'gc',
  }

  -- Habilita o uso do emmet (<C-y>,)
  use {
      'mattn/emmet-vim',
      opt = true,
      keys = { '<c-y>,' },
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
          for _, key in ipairs({'f', 'F', 't', 'T'}) do
              vim.api.nvim_del_keymap('o', key)
              vim.api.nvim_del_keymap('x', key)
              vim.api.nvim_del_keymap('n', key)
          end
      end
  }

  -- Temas
  use {'ellisonleao/gruvbox.nvim', requires = {'rktjmp/lush.nvim'}}
  use 'joshdick/onedark.vim'


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
          require'indent_blankline'.setup()
      end
  }

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
  use {
      'diepm/vim-rest-console',
      opt = true,
      ft = 'rest',
  }

  -- LSP do Nvim
  use 'neovim/nvim-lspconfig'

  -- Autocompletion framework for built-in LSP
  use {
      "hrsh7th/nvim-cmp",
      requires = {
          "hrsh7th/vim-vsnip",
          "quangnguyen30192/cmp-nvim-ultisnips",
          "hrsh7th/cmp-nvim-lsp"
          -- "hrsh7th/cmp-buffer",
      },
      config = function ()
          local cmp = require'cmp'
          local lspkind = require'lspkind'

          local t = function(str)
              return vim.api.nvim_replace_termcodes(str, true, true, true)
          end

          local check_back_space = function()
              local col = vim.fn.col(".") - 1
              return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
          end

          cmp.setup({
              snippet = {
                  expand = function(args)
                      vim.fn["UltiSnips#Anon"](args.body)
                  end,
              },
              mapping = {
                  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-e>'] = cmp.mapping.close(),
                  ['<CR>'] = cmp.mapping.confirm({
                      behavior = cmp.ConfirmBehavior.Replace,
                      select = true,
                  })
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
                  { name = 'path' },
                  { name = 'buffer' },
                  { name = 'calc' },
                  { name = 'nvim_lsp' },
                  { name = 'cmp_tabnine' },
                  { name = 'ultisnips' },
                  { name = 'emoji' },
              }
          })
      end,
  }
  -- use {
  --     'hrsh7th/nvim-compe',
  --     config = function ()
  --         require'compe'.setup {
  --             source = {
  --                 path = true;
  --                 buffer = true;
  --                 calc = true;
  --                 nvim_lsp = true;
  --                 nvim_lua = true;
  --                 tabnine = true;
  --                 ultisnips = true;
  --             };
  --         }
  --     end
  -- }

  -- TabNine
  -- use { 'tzachar/compe-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-compe' }
    use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}

  -- Plugin LSP com base no cliente lsp do neovim
  use {
      'glepnir/lspsaga.nvim',
      requires = {'neovim/nvim-lspconfig'},
      config = function ()
          require 'lspsaga'.init_lsp_saga()
      end,
      opt = true,
      module = 'lspsaga',
  }

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
end)
