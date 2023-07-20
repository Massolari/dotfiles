use "$env.HOME/Library/Application Support/nushell/nu_scripts/themes/themes/nushell-light.nu"

let-env config = {
  edit_mode: vi
  color_config: (nushell-light)
}

def nuopen [arg, --raw (-r)] { if $raw { open -r $arg } else { open $arg } }

let-env PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin' | prepend '${config.home.homeDirectory}/.ghcup/bin' | prepend '${config.home.homeDirectory}/.cargo/bin' | prepend '${config.home.homeDirectory}/.nimble/bin' | prepend '${config.home.homeDirectory}/.nix-profile/bin' | prepend '/nix/var/nix/profiles/default/bin')

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
