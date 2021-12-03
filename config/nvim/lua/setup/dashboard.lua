vim.g.dashboard_default_executive = 'telescope'

vim.g.dashboard_custom_header = {
  "███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄",
  "███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄",
  "███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███",
  "███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███",
  "███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███",
  "███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███",
  "███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███",
  " ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀"
}

local user_file = vim.fn.stdpath('config') .. '/lua/user/init.lua'

vim.g.dashboard_custom_section = {
  a = {
    description = { "  Buscar arquivo      ̩  " },
    command = "Telescope find_files",
  },
  -- c = {
  --   description = { "  Recent Projects    ‹" },
  --   command = "Telescope projects",
  -- },
  b = {
    description = { "  Arquivos recentes     " },
    command = "Telescope oldfiles",
  },
  c = {
    description = { "  Procurar nos arquivos " },
    command = "Telescope live_grep",
  },
  d = {
    description = { "  Minhas Configurações  " },
    command = ":e! " .. user_file,
  },
  e = {
    description = { "  Novo arquivo          " },
    command = ":ene!",
  },
}

local count_plugins_loaded = #vim.fn.globpath(vim.fn.stdpath('data') .. "/site/pack/packer/start", "*", 0, 1)
vim.g.dashboard_custom_footer = { count_plugins_loaded .. ' plugins carregados' }
