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


              file.".config/silicon/config".text = ''
                --theme 'Solarized (light)'
              '';
              file.".config/vifm/vifmrc".source = "${./vifmrc}";

              file.".config/vifm/colors".source = pkgs.fetchFromGitHub {
                owner = "vifm";
                repo = "vifm-colors";
                rev = "master";
                sha256 = "sha256-TMBjrgDfaSBfQlOxVoqJ/7MfOy4QbB77T6kDOql/odM=";
              };

              file."Library/Preferences/espanso/match/custom.yml".text = builtins.readFile ./espanso/match.yml;

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
                languages = [
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
                  watcher = "${config.home.homeDirectory}/.fig/tools/kitty-integration.py";
                  include = "${./kitty-theme.conf}";
                  # theme = "One Half Dark";
                  macos_thicken_font = "0.40";
                  macos_option_as_alt = "yes";
                  scrollback_pager = ''nvim -u NORC -c "set ft=man" -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - "'';
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
                extraConfig = builtins.readFile ./wezterm.lua;
              };

              zsh = {
                enable = true;
                enableAutosuggestions = true;
                initExtraFirst = ''
                  # Fig pre block. Keep at the top of this file.
                  . "$HOME/.fig/shell/zshrc.pre.zsh"
                '';
                initExtra = ''
                  path+=('${config.home.homeDirectory}/.ghcup/bin')
                  path+=('${config.home.homeDirectory}/.cargo/bin')
                  path+=('${config.home.homeDirectory}/.nimble/bin')

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
                '';
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
                  doom = "${config.home.homeDirectory}/.config/emacs/bin/doom";
                };
              };
            };
          })
        ];
      };
    };
}
