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

function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
end

set -g fish_key_bindings fish_user_key_bindings
set -x DYLD_LIBRARY_PATH "/opt/homebrew/lib"
set -x XDG_CONFIG_HOME $HOME/.config

abbr --add lg lazygit
