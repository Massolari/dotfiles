{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      username = "douglasmassolari";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ({ config, ... }:
            let
              mkDotfilesSymlink = file:
                config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${file}";
            in
            {
              home = {
                stateVersion = "22.11";
                inherit username;
                homeDirectory = "/Users/${username}";

                file.".config/nix/nix.conf".text = ''
                  experimental-features = nix-command flakes
                  trusted-users = ${username}
                '';

                # Install MacOS applications to the user environment.
                file."Applications/Home Manager Apps".source =
                  let
                    apps = pkgs.buildEnv {
                      name = "home-manager-applications";
                      paths = config.home.packages;
                      pathsToLink = "/Applications";
                    };
                  in
                  "${apps}/Applications";

                file.".aerospace.toml".source = mkDotfilesSymlink "config/aerospace.toml";
                file.".config/aerc/aerc.conf".source = mkDotfilesSymlink "config/aerc/aerc.conf";
                file.".config/bat/config".source = mkDotfilesSymlink "config/bat/config";
                file.".config/btop/btop.conf".source = mkDotfilesSymlink "config/btop/btop.conf";
                file.".config/gh/config.yml".source = mkDotfilesSymlink "config/gh/config.yml";
                file.".config/git/config".source = mkDotfilesSymlink "config/git/config";
                file.".config/kitty/kitty.conf".source = mkDotfilesSymlink "config/kitty/kitty.conf";
                file.".config/helix/languages.toml".source = mkDotfilesSymlink "config/helix/languages.toml";
                file.".config/lazygit/config.yml".source = mkDotfilesSymlink "config/lazygit/config.yml";
                file.".config/mpv/mpv.conf".source = mkDotfilesSymlink "config/mpv/mpv.conf";
                file.".config/neovide/config.toml".source = mkDotfilesSymlink "config/neovide/config.toml";
                file.".config/silicon/config".text = "--theme 'Solarized (light)'";
                file.".lynxrc".source = mkDotfilesSymlink "config/lynxrc";
                file.".w3m/keymap".source = mkDotfilesSymlink "config/w3m/keymap";
                file."Library/Application Support/iamb/config.toml".source = mkDotfilesSymlink "config/iamb/config.toml";
                file."Library/Application Support/kanata/kanata.kbd".source = mkDotfilesSymlink "config/kanata/kanata.kbd";

                packages = with pkgs; [
                  ascii-image-converter
                  bat
                  btop
                  delta
                  devbox
                  fd
                  fennel
                  fswatch
                  fzf
                  gh
                  git
                  gnupg
                  jq
                  kanata
                  kitty
                  languagetool
                  lazygit
                  lynx
                  pnpm
                  python313
                  python313Packages.pip
                  python313Packages.pynvim
                  silicon
                  tldr
                  tree-sitter
                  w3m
                  wget
                  yarn
                  yt-dlp
                ];
              };

              programs = {
                home-manager.enable = true;

                carapace.enable = true;

                direnv = {
                  enable = true;
                  nix-direnv.enable = true;
                };

                fish = {
                  enable = true;
                  shellInit = builtins.readFile ./config/fish/config.fish;
                  plugins = [
                    {
                      name = "plugin-git";
                      src = pkgs.fishPlugins.plugin-git.src;
                    }
                  ];
                };

                helix = {
                  enable = true;
                  settings = {
                    theme = "catppuccin_latte";
                    editor = {
                      bufferline = "always";
                      "line-number" = "relative";
                      "soft-wrap".enable = true;
                      shell = [ "/Users/douglasmassolari/.nix-profile/bin/nu" "-c" ];
                      lsp = {
                        display-messages = true;
                        display-inlay-hints = true;
                      };
                      "cursor-shape".insert = "bar";
                      statusline = {
                        left = [ "file-type" "file-name" "diagnostics" "mode" ];
                        center = [ "spinner" ];
                        right = [ "selections" "position" "position-percentage" ];
                        mode.normal = "";
                      };
                      "file-picker".hidden = false;
                      "indent-guides".render = true;
                    };
                    keys = {
                      normal = {
                        "C-h" = "jump_view_left";
                        "C-j" = "jump_view_down";
                        "C-k" = "jump_view_up";
                        "C-l" = "jump_view_right";
                        "C-e" = "scroll_down";
                        "C-y" = "scroll_up";
                        "space".s = ":write";
                        "space".o = "symbol_picker";
                        "space".O = "workspace_symbol_picker";
                        "space".q = ":buffer-close";
                        X = "extend_line_above";
                      };
                      insert = {
                        j.k = "normal_mode";
                      };
                    };
                  };
                };

                starship.enable = true;

                ripgrep.enable = true;

                yazi = {
                  enable = true;
                  enableFishIntegration = true;
                  enableZshIntegration = true;
                  settings = {
                    manager = {
                      sort_by = "natural";
                    };
                  };
                };

                zoxide.enable = true;
              };
            })

          ({ pkgs, ... }: {
            nix = {
              registry = {
                nixpkgs.flake = nixpkgs;
              };
            };
          })
        ];
      };
    };
}
