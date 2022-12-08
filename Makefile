switch:
	home-manager switch --flake .

activate:
	nix --extra-experimental-features 'nix-command flakes' build .#homeConfigurations.douglasmassolari.activationPackage

update:
	nix flake update

fix-mac-update:
		@echo Add this:
		@echo '# Nix'
		@echo 'if [ -e '\''/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'\'' ]; then'
		@echo '  . '\''/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'\'
		@echo fi
		@echo '# End Nix'
		@echo 'to `/etc/zshrc`'

