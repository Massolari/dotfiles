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

              file.".w3m/keymap".text = ''
                keymap C-b PREV_PAGE
                keymap C-f NEXT_PAGE
                keymap b PREV_WORD
                keymap C-u PREV_HALF_PAGE
                keymap C-d NEXT_HALF_PAGE
                keymap C-y DOWN
                keymap C-e UP
                keymap C-o BOOKMARK
                keymap C-a ADD_BOOKMARK

                keymap Sd COMMAND "GOTO https://duckduckgo.com/lite/; NEXT_LINK; GOTO_LINK"
                keymap Sg COMMAND "GOTO https://google.com; GOTO_LINE 6; NEXT_LINK; GOTO_LINK"
                keymap Se COMMAND "GOTO https://stackexchange.com; GOTO_LINE 7; NEXT_LINK; GOTO_LINK"
                keymap Sw COMMAND "GOTO https://en.m.wikipedia.org/wiki/Main_Page; GOTO_LINE 18; NEXT_LINK; GOTO_LINK"
              '';

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
                w3m
                wget
                yarn
              ];
            };

            programs = {
              home-manager.enable = true;

              alacritty = {
                enable = true;
                settings = {
                  font = {
                    normal.family = "JetBrainsMono Nerd Font";
                    size = 12.0;
                  };
                };
              };

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
                  condition = "gitdir:~/tweag";
                }
                {
                  path = "~/tweag/.gitconfig";
                  condition = "gitdir:~/tweag/";
                }
                {
                  path = "~/tweag/metronome/.gitconfig";
                  condition = "gitdir:~/tweag/metronome/";
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
                  size = 12;
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
                  macos_thicken_font = "0.25";
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
