-- Função para alterar o quickfix
local function toggle_quickfix ()
  if vim.g.quickfix_win == nil then
    vim.cmd('botright copen 10')
    vim.g.quickfix_win = vim.fn.bufnr('$')
  else
    vim.cmd('cclose')
    vim.api.nvim_del_var('quickfix_win')
  end
end

local function toggle_location_list ()
  if vim.g.location_list_win == nil then
    vim.cmd('lopen 10')
    vim.g.location_list_win = vim.fn.bufnr('$')
  else
    vim.cmd('lclose')
    vim.api.nvim_del_var('location_list_win')
  end
end

return {
  toggle_quickfix = toggle_quickfix,
  toggle_location_list = toggle_location_list,
}
