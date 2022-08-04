{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-darwin";
      username = "douglasmassolari";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ({ config, ... }: {
            home = {
              stateVersion = "22.11";
              inherit username;
              homeDirectory = "/Users/${username}";

              file.".config/nix/nix.conf".text = ''
                experimental-features = nix-command flakes
                '';

              # Install MacOS applications to the user environment.
              file."Applications/Home Manager Apps".source = let
                apps = pkgs.buildEnv {
                  name = "home-manager-applications";
                  paths = config.home.packages;
                  pathsToLink = "/Applications";
                };
              in "${apps}/Applications";

              packages = with pkgs; [
                bitwarden-cli
                elmPackages.elm-language-server
                fd
                fennel
                fnlfmt
                fswatch
                imagemagick
                neovim
                nodejs
                ripgrep
                rsync
                wget
                yarn
              ];
            };

            programs = {
              home-manager.enable = true;

              bat.enable = true;

              emacs.enable = true;

              fzf.enable = true;

              git = {
                enable = true;
                userName = "Douglas M.";
                userEmail = "douglasmassolari@hotmail.com";
                includes = [
                {
                  path = "~/tweag/.gitconfig";
                  condition = "gitdir:~/tweag/";
                }
                ];
                extraConfig = {
                  core.editor = "nvim";
                  init.defaultBranch = "master";
                  pull.ff = "only";
                  github.user = "Massolari";
                };
                delta = {
                  enable = true;
                  options.light = true;
                };
              };

              gh = {
                enable = true;
                settings = {
                  git_protocol = "ssh";
                  editor = "nvim";
                  prompt = "enable";
                };
              };

              kitty = {
                enable = true;
                font = {
                  name = "JetBrainsMono Nerd Font";
                  size = 14;
                };
                keybindings = {
                  "shift+cmd+t" = "new_tab_with_cwd";
                  "kitty_mod+j" = "next_tab";
                  "kitty_mod+k" = "previous_tab";
                  "kitty_mod+enter" = "new_window_with_cwd";
                  "kitty_mod+z" = "toggle_layout stack";
                };
                settings = {
                  tab_bar_style = "powerline";
                  watcher = "${config.home.homeDirectory}.fig/tools/kitty-integration.py";
                  include = "${./kitty-theme.conf}";
                };
              };

              lazygit = {
                enable = true;
                settings.gui.theme.lightTheme = true;
              };

              starship.enable = true;

              zsh = {
                enable = true;
                enableAutosuggestions = true;
                zplug = {
                  enable = true;
                  plugins = [
                  { name = "z-shell/F-Sy-H"; }
                  { name = "jeffreytse/zsh-vi-mode"; }
                  { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
                  ];
                };
                localVariables = {
                  ZVM_VI_INSERT_ESCAPE_BINDKEY = "jk";
                };
                shellAliases = {
                  lg = "lazygit";
                  nvid = "${config.home.homeDirectory}/neovide/target/release/neovide";
                  ll = "ls -l";
                  ".." = "cd ..";
                  "nsx" = "nix-shell --system x86_64-darwin";
                  doom = "${config.home.homeDirectory}/.emacs.d/bin/doom";
                };
              };
            };
          })
        ];
      };
  };
}
