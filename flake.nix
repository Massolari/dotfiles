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
                kakoune
                neovim
                nodejs
                ripgrep
                rsync
                w3m
                wget
                yarn
                yt-dlp
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

              helix = {
                enable = true;
                settings = {
                  theme = "onelight";
                  editor = {
                    "line-number" = "relative";
                    "cursor-shape".insert = "bar";
                    statusline = {
                       left = ["mode" "file-type" "file-name" "diagnostics"];
                       center = ["spinner"];
                       right = ["selections" "position" "position-percentage"];
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
                    "file-types" = ["fnl"];
                    "comment-token" = ";";
                    "roots" = [];
                    grammar = "tree-sitter-fennel";
                    # grammar = {
                    #   name = "tree-sitter-fennel";
                    #   source = {
                    #     git = "https://github.com/travonted/tree-sitter-fennel";
                    #     rev = "517195970428aacca60891b050aa53eabf4ba78d";
                    #   };
                    # };
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
                  watcher = "${config.home.homeDirectory}.fig/tools/kitty-integration.py";
                  include = "${./kitty-theme.conf}";
                  macos_thicken_font = "0.40";
                  macos_option_as_alt = "yes";
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
                initExtra = ''
                  path+=('${config.home.homeDirectory}/.ghcup/bin')
                  path+=('${config.home.homeDirectory}/.cargo/bin')
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
                  doom = "${config.home.homeDirectory}/.emacs.d/bin/doom";
                };
              };
            };
          })
        ];
      };
  };
}
