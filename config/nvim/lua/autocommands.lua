vim.cmd([[
" Guardar posição do cursor
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
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
]])
