use "@home@/Library/Application Support/nushell/nu_scripts/themes/themes/nushell-light.nu"
use "@home@/Library/Application Support/nushell/nu_scripts/aliases/git/git-aliases.nu" *

let-env config = {
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

let-env PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin' | prepend '@home@/.ghcup/bin' | prepend '@home@/.cargo/bin' | prepend '@home@/.nimble/bin' | prepend '@home@/.nix-profile/bin' | prepend '/nix/var/nix/profiles/default/bin' | prepend '@home@/.local/bin')

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

