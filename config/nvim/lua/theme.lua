if vim.g.colors_name == nil then
  vim.cmd('colorscheme gruvbox')
end

vim.cmd('highlight NormalFloat guibg=' .. require'functions'.get_color('CursorLine', 'bg', 'Normal'))

vim.cmd [[highlight CmpItemMenu guifg=Normal]]

local signs = { Error = " ", Warn = " ", Hint = " ", Information = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
