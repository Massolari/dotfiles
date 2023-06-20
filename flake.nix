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
          ({ config, ... }: {
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


              file.".config/iamb/config.json".text = builtins.toJSON {
                profiles = {
                  dougmass = {
                    user_id = "@dougmass:matrix.org";
                    url = "https://matrix.org";
                  };
                  douglas = {
                    user_id = "@douglas:massolari.us.to";
                    url = "https://massolari.us.to";
                  };
                };
                default_profile = "douglas";
              };

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

              file."Library/Preferences/espanso/match/custom.yml".text = builtins.readFile ./config/espanso/match.yml;

              file.".w3m/keymap".text = builtins.readFile ./config/w3m/keymap;

              packages = with pkgs; [
                ascii-image-converter
                bitwarden-cli
                elmPackages.elm-language-server
                exa
                fd
                fennel
                fswatch
                gomuks
                imagemagick
                jdk11
                jq
                languagetool
                luajitPackages.luarocks
                mpv
                neovim
                nodejs
                python310
                python310Packages.pip
                python310Packages.pynvim
                ripgrep
                rsync
                silicon
                terminal-notifier
                tree-sitter
                vifm
                w3m
                wget
                yarn
                yt-dlp
                zoxide
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
                  git_protocol = "ssh";
                  editor = "nvim";
                  prompt = "enable";
                };
              };

              helix = {
                enable = true;
                settings = {
                  theme = "onelight";
                  editor = {
                    "line-number" = "relative";
                    "cursor-shape".insert = "bar";
                    statusline = {
                      left = [ "mode" "file-type" "file-name" "diagnostics" ];
                      center = [ "spinner" ];
                      right = [ "selections" "position" "position-percentage" ];
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
                      "space".b = {
                        b = "buffer_picker";
                        d = ":bc";
                        s = ":w";
                      };
                      X = "extend_line_above";
                    };
                    insert = {
                      j.k = "normal_mode";
                    };
                  };
                };
                languages = {
                  language = [
                    {
                      name = "fennel";
                      scope = "source.fnl";
                      "file-types" = [ "fnl" ];
                      "comment-token" = ";";
                      "roots" = [ ];
                      grammar = "tree-sitter-fennel";
                    }
                  ];
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
                  include = "${./config/kitty/theme/solarized.conf}";
                  macos_option_as_alt = "yes";
                  scrollback_pager = ''nvim -c "set ft=man" -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - " -c "norm G"'';
                  tab_bar_style = "powerline";
                  watcher = "${config.home.homeDirectory}/.fig/tools/kitty-integration.py";
                };
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

              zsh = {
                enable = true;
                enableAutosuggestions = true;
                initExtraFirst = builtins.readFile ./config/zsh/pre.zsh;
                initExtra = builtins.readFile (pkgs.substituteAll {
                  src = ./config/zsh/zshrc.zsh;
                  home = config.home.homeDirectory;
                });
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
                  ".." = "cd ..";
                  doom = "${config.home.homeDirectory}/.config/emacs/bin/doom";
                  iamb = "iamb -C ${config.home.homeDirectory}/.config";
                  lg = "lazygit";
                  ll = "ls -l";
                  nsb = "nix-shell --builders '@/etc/nix/machines'";
                  nsx = "nix-shell --system x86_64-darwin";
                  nvid = "${config.home.homeDirectory}/neovide/target/release/neovide";
                };
              };
            };
          })
        ];
      };
    };
}
