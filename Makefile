switch:
	home-manager switch --flake .

activate:
	nix --extra-experimental-features 'nix-command flakes' build .#homeConfigurations.douglasmassolari.activationPackage

update:
	nix flake update
