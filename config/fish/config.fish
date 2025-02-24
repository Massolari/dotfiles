set PATH \
  $HOME/.cargo/bin\
  $HOME/.docker/bin\
  $HOME/.ghcup/bin\
  $HOME/.local/bin\
  $HOME/.local/share/nvim/mason/bin/\
  $HOME/.nimble/bin\
  $HOME/.nix-profile/bin\
  $HOME/go/bin\
  /nix/var/nix/profiles/default/bin\
  /opt/homebrew/bin\
  /usr/local/bin\
  /opt/homebrew/opt/openjdk/bin\
  $PATH

set -g fish_key_bindings fish_vi_key_bindings
set DYLD_LIBRARY_PATH "/opt/homebrew/lib"
set XDG_CONFIG_HOME $HOME/.config

abbr --add lg lazygit
