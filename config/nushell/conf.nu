use "~/Library/Application Support/nushell/nu_scripts/themes/nu-themes/nushell-light.nu"
use "~/Library/Application Support/nushell/nu_scripts/aliases/git/git-aliases.nu" *

$env.config = {
  edit_mode: vi
  color_config: (nushell-light)
  keybindings: [
      {
        name: completion_menu
        modifier: none
        keycode: tab
        mode: [emacs vi_normal vi_insert]
        event: {
          until: [
            { send: menu name: completion_menu }
            { send: menunext }
          ]
        }
      }
      {
        name: history_menu
        modifier: control
        keycode: char_r
        mode: [emacs, vi_insert, vi_normal]
        event: { send: menu name: history_menu }
      }
      {
        name: help_menu
        modifier: none
        keycode: f1
        mode: [emacs, vi_insert, vi_normal]
        event: { send: menu name: help_menu }
      }
      {
        name: completion_previous_menu
        modifier: shift
        keycode: backtab
        mode: [emacs, vi_normal, vi_insert]
        event: { send: menuprevious }
      }
      {
        name: move_left
        modifier: control
        keycode: char_b
        mode: [emacs, vi_insert]
        event: {
            until: [
                {send: menuleft}
                {send: left}
            ]
        }
      }
      {
        name: move_right_or_take_history_hint
        modifier: control
        keycode: char_f
        mode: [emacs, vi_insert]
        event: {
            until: [
                {send: historyhintcomplete}
                {send: menuright}
                {send: right}
            ]
        }
      }
    ]
}

def nuopen [arg, --raw (-r)] { if $raw { open -r $arg } else { open $arg } }

$env.PATH = ($env.PATH
  | split row (char esep)
  | prepend '/opt/homebrew/bin'
  | prepend $'($env.HOME)/.ghcup/bin'
  | prepend $'($env.HOME)/.cargo/bin'
  | prepend $'($env.HOME)/.nimble/bin'
  | prepend $'($env.HOME)/.nix-profile/bin'
  | prepend '/nix/var/nix/profiles/default/bin'
  | prepend $'($env.HOME)/.local/bin'
  | prepend $'($env.HOME)/.docker/bin'
  | prepend $'($env.HOME)/.local/share/nvim/mason/bin/'
)

def nvid [] { which nvim | get path | /Applications/neovide.app/Contents/MacOS/neovide --neovim-bin $in }
