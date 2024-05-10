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


                file.".config/helix/languages.toml".source = mkDotfilesSymlink "config/helix/languages.toml";

                file.".config/iamb/config.json".text = builtins.toJSON {
                  default_profile = "douglas";
                  profiles = {
                    dougmass = {
                      user_id = "@dougmass:matrix.org";
                      url = "https://matrix.org";
                    };
                    douglas = {
                      user_id = "@douglas:massolari.us.to";
                      url = "https://massolari.us.to";
                    };
                    beeper = {
                      user_id = "@douglas-massolari:beeper.com";
                      url = "https://matrix.beeper.com";
                    };
                  };
                  settings = {
                    image_preview = { };
                    username_display = "displayname";
                  };
                };

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

                file."Library/Application Support/nushell/nu_scripts".source = pkgs.fetchFromGitHub {
                  owner = "nushell";
                  repo = "nu_scripts";
                  rev = "master";
                  sha256 = "sha256-FmLoF+QieZxjhFglqmSHyPOjj3T8XSn3nCvaZ5RP8Z4=";
                };

                file.".skhdrc".source = mkDotfilesSymlink "config/skhdrc";

                file.".w3m/keymap".source = mkDotfilesSymlink "config/w3m/keymap";

                file.".yabairc".source = mkDotfilesSymlink "config/yabairc";

                packages = with pkgs; [
                  ascii-image-converter
                  bitwarden-cli
                  devbox
                  fennel
                  fswatch
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
                  enableNushellIntegration = true;
                  nix-direnv.enable = true;
                };

                emacs = {
                  enable = true;
                  package = pkgs.emacs-macport;
                };

                fd.enable = true;

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
                    include = "${./config/kitty/theme/one-light.conf}";
                    macos_option_as_alt = "yes";
                    scrollback_pager = ''/Users/douglasmassolari/.nix-profile/bin/nvim -c "set ft=man" -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - " -c "norm G"'';
                    tab_bar_style = "powerline";
                    # watcher = "${config.home.homeDirectory}/.fig/tools/kitty-integration.py";
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

                mpv.enable = true;

                nushell = {
                  enable = true;

                  configFile.source = ./config/nushell/conf.nu;

                  environmentVariables = {
                    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
                    EDITOR = "nvim";
                    MANPAGER = "'nvim +Man!'";
                    LC_TYPE = "pt_BR.UTF-8";
                    LC_ALL = "pt_BR.UTF-8";
                  };

                  shellAliases = {
                    open = "^open";
                    ".." = "cd ..";
                    doom = "${config.home.homeDirectory}/.config/emacs/bin/doom";
                    iamb = "iamb -C ${config.home.homeDirectory}/.config";
                    lg = "lazygit";
                    ll = "ls -l";
                    nsb = "bash -c 'source ~/.bashrc && nsb'";
                    ndb = "bash -c 'source ~/.bashrc && ndb'";
                    nsx = "nix-shell --system x86_64-darwin";
                    nvid = "/Applications/neovide.app/Contents/MacOS/neovide";
                    zed = "/Applications/Zed.app/Contents/MacOS/zed";
                  };
                };

                ripgrep.enable = true;

                yazi = {
                  enable = true;
                  enableNushellIntegration = true;
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
