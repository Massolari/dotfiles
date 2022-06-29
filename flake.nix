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
      pkgs = nixpkgs.legacyPackages.${system};

      homePackages = with pkgs; [
        bitwarden-cli
          elmPackages.elm-language-server
          fd
          fswatch
          fnlfmt
          neovim
          nodejs
          ripgrep
          rsync
          wget
          yarn
      ];

    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
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
                  paths = homePackages;
                  pathsToLink = "/Applications";
                };
              in "${apps}/Applications";

              packages = homePackages;
            };

            programs = {
              home-manager.enable = true;

              bat.enable = true;

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
                  watcher = "/Users/douglasmassolari/.fig/tools/kitty-integration.py";
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
                  nvid = "/Users/douglasmassolari/neovide/target/release/neovide";
                  ll = "ls -l";
                  ".." = "cd ..";
                  "nsx" = "nix-shell --system x86_64-darwin";
                };
              };
            };
          }
        ];
        # configuration = {config, pkgs, ...}: {
        #   programs.home-manager.enable = true;
        #
        #   home.file.".config/nix/nix.conf".text = ''
        #     experimental-features = nix-command flakes
        #   '';
        #
        #   # Install MacOS applications to the user environment.
        #   home.file."Applications/Home Manager Apps".source = let
        #     apps = pkgs.buildEnv {
        #       name = "home-manager-applications";
        #       paths = config.home.packages;
        #       pathsToLink = "/Applications";
        #     };
        #   in "${apps}/Applications";
        #
        #   programs.bat.enable = true;
        #
        #   programs.fzf.enable = true;
        #
        #   programs.git = {
        #     enable = true;
        #     userName = "Douglas M.";
        #     userEmail = "douglasmassolari@hotmail.com";
        #     includes = [
        #       {
        #         path = "~/tweag/.gitconfig";
        #         condition = "gitdir:~/tweag/";
        #       }
        #     ];
        #     extraConfig = {
        #       core.editor = "nvim";
        #       init.defaultBranch = "master";
        #       pull.ff = "only";
        #     };
        #     delta = {
        #       enable = true;
        #       options.light = true;
        #     };
        #   };
        #
        #   programs.gh = {
        #     enable = true;
        #     settings = {
        #       git_protocol = "ssh";
        #       editor = "nvim";
        #       prompt = "enable";
        #     };
        #   };
        #
        #   programs.kitty = {
        #     enable = true;
        #     font = {
        #       name = "JetBrainsMono Nerd Font";
        #       size = 14;
        #     };
        #     keybindings = {
        #       "shift+cmd+t" = "new_tab_with_cwd";
        #       "kitty_mod+j" = "next_tab";
        #       "kitty_mod+k" = "previous_tab";
        #       "kitty_mod+enter" = "new_window_with_cwd";
        #       "kitty_mod+z" = "toggle_layout stack";
        #     };
        #     settings = {
        #       tab_bar_style = "powerline";
        #       watcher = "/Users/douglasmassolari/.fig/tools/kitty-integration.py";
        #       include = "${./kitty-theme.conf}";
        #     };
        #   };
        #
        #   programs.lazygit = {
        #     enable = true;
        #     settings.gui.theme.lightTheme = true;
        #   };
        #
        #   programs.starship.enable = true;
        #
        #   programs.zsh = {
        #     enable = true;
        #     enableAutosuggestions = true;
        #     zplug = {
        #       enable = true;
        #       plugins = [
        #         { name = "z-shell/F-Sy-H"; }
        #         { name = "jeffreytse/zsh-vi-mode"; }
        #         { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
        #       ];
        #     };
        #     localVariables = {
        #       ZVM_VI_INSERT_ESCAPE_BINDKEY = "jk";
        #     };
        #     shellAliases = {
        #       lg = "lazygit";
        #       nvid = "/Users/douglasmassolari/neovide/target/release/neovide";
        #       ll = "ls -l";
        #       ".." = "cd ..";
        #       "nsx" = "nix-shell --system x86_64-darwin";
        #     };
        #   };
        #
        #   home.packages = with pkgs; [
        #     bitwarden-cli
        #     elmPackages.elm-language-server
        #     fd
        #     fswatch
        #     fnlfmt
        #     neovim
        #     nodejs
        #     ripgrep
        #     rsync
        #     wget
        #     yarn
        #   ];
        #   #home.file.".config/nixpkgs/home/flake.nix".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/flake.nix";
        # };
      };
  };
}
