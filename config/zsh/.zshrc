path+=('@home@/.ghcup/bin')
path+=('@home@/.cargo/bin')
path+=('@home@/.nimble/bin')

# Setup zoxide
eval "$(zoxide init zsh)"

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/zshrc.post.zsh"
export MANPAGER='nvim +Man!'

