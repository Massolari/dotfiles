-- Tema claro
vim.g.gruvbox_italic = 1
vim.g.material_style = 'lighter'
vim.cmd('colorscheme toast')
vim.opt.background = 'light'

-- Encoding
vim.opt.fileencoding = 'utf-8'
vim.opt.fileformats = { 'unix','dos','mac' }

-- Comportamento do Tab
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Busca
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

-- Arquivo swap
vim.opt.swapfile = false

local envShell = os.getenv('SHELL')
if envShell ~= "" then
  vim.opt.shell = envShell
else
  vim.opt.shell = '/bin/sh'
end

-- Gerenciamento de sessão
vim.g.session_directory = "~/.vim/session"
vim.g.session_autoload = "no"
vim.g.session_autosave = "no"
vim.g.session_command_aliases = 1

-- Opções para o vim-rest-console
vim.g.vrc_curl_opts = {
  ['-sS'] = '',
  ['--connect-timeout'] = 10,
  ['-i'] = '',
  ['--max-time'] = 60,
  ['-k'] = '',
}

-- Formatar resposta em JSON
vim.g.vrc_auto_format_response_patterns = {
  json = 'python3 -m json.tool',
}
