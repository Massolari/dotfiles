-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Desabilitar editorconfig para fugitive
vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*' }

-- Configurar o lexima com o compe
vim.g.lexima_no_default_rules = 1
vim.fn['lexima#set_default_rules']()

-- Gruvbox
vim.g.gruvbox_italic = 1

-- Material
vim.g.material_style = 'lighter'

-- Neon
vim.g.neon_style = 'light'
vim.g.neon_bold = true

-- Tokyonight
vim.g.tokyonight_style = 'day'

-- Github
vim.g.function_style = 'italic'

-- Colorscheme
-- vim.cmd('colorscheme github_light')


-- vim.opt.background = 'dark'
-- vim.cmd('colorscheme gruvbox')
