local

act = wezterm.action
local io = require "io"
local os = require "os"

wezterm.on("trigger-nvim-with-scrollback", function(window, pane)
  -- Retrieve the current viewport's text.
  -- Pass an optional number of lines (eg: 2000) to retrieve
  -- that number of lines starting from the bottom of the viewport
  local scrollback = pane:get_lines_as_text(2000);

  -- Create a temporary file to pass to vim
  local name = os.tmpname();
  local f = io.open(name, "w+");
  f:write(scrollback);
  f:flush();
  f:close();

  -- Open a new window running vim and tell it to open the file
  window:perform_action(wezterm.action {
    SpawnCommandInNewWindow = {
      args = { os.getenv('HOME') .. "/.nix-profile/bin/nvim", name, '-c', 'norm G' }
    }
  }, pane)

  -- wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous
  -- wrt. running this script and are not awaitable, so we just pick
  -- a number.
  wezterm.sleep_ms(1000);
  os.remove(name);
end)

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  adjust_window_size_when_changing_font_size = false,
  color_scheme = "Github (base16)",
  colors = {
    tab_bar = {
      background = "#f6f8fa",
      active_tab = {
        bg_color = "#f6f8fa",
        fg_color = "#24292e",
        intensity = "Bold",
        underline = "Single",
      },
      inactive_tab = {
        bg_color = "#f6f8fa",
        fg_color = "#586069",
      },
      new_tab = {
        bg_color = "#f6f8fa",
        fg_color = "#24292e",
      },
      new_tab_hover = {
        bg_color = "#f6f8fa",
        fg_color = "#24292e",
        intensity = "Bold",
      },
    }
  },
  font = wezterm.font("JetBrainsMono Nerd Font"),
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    {
      key = 'T',
      mods = 'CMD',
      action = act.SpawnTab 'DefaultDomain',
    },
    {
      key = 't',
      mods = 'CMD',
      action = act.SpawnCommandInNewTab {
        label = 'Open new tab in home folder',
        cwd = wezterm.home_dir
      },
    },
    {
      key = 'Enter',
      mods = 'CMD',
      action = act.SplitPane {
        direction = 'Down',
      },
    },
    {
      key = 'Enter',
      mods = 'CMD|SHIFT',
      action = act.SplitPane {
        direction = 'Right',
      },
    },
    {
      key = 'r',
      mods = 'CMD',
      action = act.ActivateKeyTable {
        name = 'resize_pane',
        one_shot = false,
      },
    },
    {
      key = 'Z',
      mods = 'CTRL',
      action = act.TogglePaneZoomState,
    },
    {
      key = ']',
      mods = 'CMD',
      action = act.ActivatePaneDirection 'Next',
    },
    {
      key = '[',
      mods = 'CMD',
      action = act.ActivatePaneDirection 'Prev',
    },
    {
      key = 'J',
      mods = 'CTRL',
      action = act.ActivateTabRelative(-1),
    },
    {
      key = 'K',
      mods = 'CTRL',
      action = act.ActivateTabRelative(1),
    },
    {
      key = 'F',
      mods = 'CTRL',
      action = act.RotatePanes 'Clockwise',
    },
    {
      key = 'B',
      mods = 'CTRL',
      action = act.RotatePanes 'CounterClockwise',
    },
    {
      key = "E",
      mods = "CTRL",
      action = act { EmitEvent = "trigger-nvim-with-scrollback" }
    },
    {
      key = "q",
      mods = "CTRL",
      action = act { SendString="\x11" }
    },
  },
  key_tables = {
    resize_pane = {
      { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'H', action = act.AdjustPaneSize { 'Left', 10 } },
      { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'L', action = act.AdjustPaneSize { 'Right', 10 } },
      { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'K', action = act.AdjustPaneSize { 'Up', 10 } },
      { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },
      { key = 'J', action = act.AdjustPaneSize { 'Down', 10 } },

      -- Cancel the mode by pressing escape
      { key = 'Enter', action = 'PopKeyTable' },
    },
  },
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
}
