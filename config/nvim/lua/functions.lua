-- Alterar o quickfix
local function toggle_quickfix ()
  local is_quickfix_open = vim.fn.len(vim.fn.filter(vim.fn.getwininfo(), 'v:val.quickfix && !v:val.loclist')) > 0

  if is_quickfix_open then
    vim.cmd('cclose')
  else
    vim.cmd('botright copen 10')
  end
end

-- Alterar a location list
local function toggle_location_list ()
  local is_location_list_open = vim.fn.len(vim.fn.filter(vim.fn.getwininfo(), '!v:val.quickfix && v:val.loclist')) > 0

  if is_location_list_open then
    vim.cmd('lclose')
  else
    local status, err = pcall(vim.cmd, 'lopen 10')
    if not status then
      print(err)
    end
  end
end

-- Executar comando tratando parâmetros de input
local function command_with_args(prompt, default, completion, command)
  local status, input = pcall(vim.fn.input, prompt, '', completion)
  if status == false then
    return
  end

  if input == '' and default ~= nil then
    input = default
  end
  vim.cmd(":" .. command .. " " .. input)
end

-- Criar nova branch e fazer checkout
local function checkout_new_branch()
  local branch_name = vim.fn.input("New branch name> ")
  if branch_name == "" then
    return
  end
  vim.cmd('echo "\r"')
  vim.cmd("echohl Directory")
  vim.cmd(":Git checkout -b " .. branch_name)
  vim.cmd("echohl None")
end

-- Get the user input for what he wants to search for with vimgrep
-- if it's empty, abort, if it's not empty get the user input for the target folder, if
-- it's not specified, defaults to `git ls-files`
local function vim_grep()
  local searchStatus, input = pcall(vim.fn.input, 'Search for: ', '')
  if searchStatus == false or input == '' then
    print('Aborted')
    return
  end

  local folderStatus, target = pcall(vim.fn.input, 'Target folder/files (git ls-files): ', '', 'file')
  if folderStatus == false then
    print('Aborted')
    return
  end
  -- local target = vim.fn.input('Target folder/files (git ls-files): ', '', 'file')
  if target == '' then
    target = '`git ls-files`'
  end

  local status, err = pcall(vim.cmd, ':vimgrep /' .. input .. '/gj ' .. target)
  if status == false then
    print(err)
    return
  end
  vim.cmd(':copen')
end

-- Lazygit
local Terminal = require'toggleterm.terminal'.Terminal
local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })

local function lazygit_toggle()
  lazygit:toggle()
end

return {
  toggle_quickfix = toggle_quickfix,
  toggle_location_list = toggle_location_list,
  checkout_new_branch = checkout_new_branch,
  command_with_args = command_with_args,
  vim_grep = vim_grep,
  lazygit_toggle = lazygit_toggle,
}
