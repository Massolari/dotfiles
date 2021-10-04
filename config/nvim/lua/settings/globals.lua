-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- -- Gruvbox
vim.g.gruvbox_italic = 1

-- -- Material
vim.g.material_style = 'lighter'

-- -- Neon
vim.g.neon_style = 'light'
vim.g.neon_bold = true

-- -- Tokyonight
vim.g.tokyonight_style = 'day'

-- vim.cmd('colorscheme github_light')
require'github-theme'.setup({
  theme_style = 'light',
  dark_float = true,
  comment_style = 'italic',
  function_style = 'italic',
  keyword_style = 'italic'
})
