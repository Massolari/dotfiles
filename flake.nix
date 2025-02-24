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

                file.".config/helix/languages.toml".source = mkDotfilesSymlink "config/helix/languages.toml";

                file."Library/Application Support/iamb/config.toml".source = mkDotfilesSymlink "config/iamb/config.toml";

                file.".config/neovide/config.toml".source = mkDotfilesSymlink "config/neovide/config.toml";

                file.".config/silicon/config".text = "--theme 'Solarized (light)'";

                file.".config/vifm/vifmrc".source = pkgs.substituteAll {
                  src = ./config/vifmrc;
                  favicons = pkgs.fetchFromGitHub
                    {
                      owner = "thimc";
                      repo = "vifm_devicons";
                      rev = "master";
                      sha256 = "sha256-MYbOob60TzIn+2v64z/6HwnxNoDAZnOoYLLYikUA078=";
                    } + "/favicons.vifm";
                };

                file.".config/vifm/colors".source = pkgs.fetchFromGitHub {
                  owner = "vifm";
                  repo = "vifm-colors";
                  rev = "master";
                  sha256 = "sha256-TMBjrgDfaSBfQlOxVoqJ/7MfOy4QbB77T6kDOql/odM=";
                };

                file."Library/Preferences/espanso/match/custom.yml".source = mkDotfilesSymlink "config/espanso/match.yml";


                file.".w3m/keymap".source = mkDotfilesSymlink "config/w3m/keymap";

                packages = with pkgs; [
                  ascii-image-converter
                  bitwarden-cli
                  devbox
                  fennel
                  fswatch
                  gomuks
                  htop
                  imagemagick
                  jdk11
                  jq
                  languagetool
                  luajitPackages.luarocks
                  neovim
                  nodejs
                  python310
                  python310Packages.pip
                  python310Packages.pynvim
                  silicon
                  terminal-notifier
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

                aerc = {
                  enable = true;
                  extraConfig = {
                    filters = {
                      "text/plain" = "colorize";
                      "text/calendar" = "calendar";
                      "message/delivery-status" = "colorize";
                      "message/rfc822" = "colorize";
                      "text/html" = "html | colorize";
                    };
                  };
                };

                alacritty = {
                  enable = true;
                  settings = {
                    font = {
                      normal.family = "Iosevka Nerd Font";
                      size = 13.0;
                    };
                    window = {
                      decorations = "None";
                    };
                  };
                };

                bat.enable = true;

                carapace.enable = true;

                direnv = {
                  enable = true;
                  nix-direnv.enable = true;
                };

                emacs = {
                  enable = true;
                  package = pkgs.emacs-macport;
                };

                fd.enable = true;

                fish = {
                  enable = true;
                  shellInit = builtins.readFile ./config/fish/config.fish;
                };

                fzf.enable = true;

                git = {
                  enable = true;
                  lfs.enable = true;
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
                    version = "1";
                    git_protocol = "ssh";
                    editor = "nvim";
                    prompt = "enable";
                  };
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

                kitty = {
                  enable = true;
                  font = {
                    name = "Iosevka Nerd Font";
                    size = 14;
                  };
                  keybindings = {
                    "shift+cmd+t" = "new_tab_with_cwd";
                    "kitty_mod+j" = "previous_tab";
                    "kitty_mod+k" = "next_tab";
                    "kitty_mod+enter" = "new_window_with_cwd";
                    "kitty_mod+z" = "toggle_layout stack";
                  };
                  settings = {
                    hide_window_decorations = "yes";
                    include = "${./config/kitty/theme/catppuccin-latte.conf}";
                    macos_option_as_alt = "yes";
                    scrollback_pager = ''/Users/douglasmassolari/.nix-profile/bin/nvim -c "set ft=man" -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - " -c "norm G"'';
                    tab_bar_style = "powerline";
                    # watcher = "${config.home.homeDirectory}/.fig/tools/kitty-integration.py";
                  };
                  shellIntegration.enableFishIntegration = true;
                };

                lazygit = {
                  enable = true;
                  settings.gui = {
                    theme = {
                      lightTheme = true;
                      defaultFgColor = [ "black" ];
                    };
                    showIcons = true;
                  };
                };

                starship.enable = true;

                wezterm = {
                  enable = true;
                  extraConfig = builtins.readFile ./config/wezterm.lua;
                };

                mpv.enable = true;

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
