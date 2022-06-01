{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    homeConfigurations.douglasmassolari = home-manager.lib.homeManagerConfiguration {
      system = "x86_64-darwin";
      pkgs = nixpkgs.legacyPackages.x86_64-darwin;
      username = "douglasmassolari";
      homeDirectory = "/Users/douglasmassolari";
      configuration = {config, pkgs, ...}: {
        programs.home-manager.enable = true;

        home.file.".config/nix/nix.conf".text = ''
          experimental-features = nix-command flakes
        '';

        # Install MacOS applications to the user environment.
        home.file."Applications/Home Manager Apps".source = let
          apps = pkgs.buildEnv {
            name = "home-manager-applications";
            paths = config.home.packages;
            pathsToLink = "/Applications";
          };
        in "${apps}/Applications";

        programs.bat.enable = true;

        programs.fzf.enable = true;

        programs.git = {
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
        };

        programs.gh = {
          enable = true;
          settings = {
            git_protocol = "ssh";
            editor = "nvim";
            prompt = "enable";
          };
        };

        programs.kitty = {
          enable = true;
          font = {
            # package = null;
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

        programs.lazygit = {
          enable = true;
          settings.gui.theme = {
            lightTheme = true;
          };
        };

        programs.starship = {
          enable = true;
          enableZshIntegration = true;
        };

        programs.zsh = {
          enable = true;
          enableAutosuggestions = true;
          zplug = {
            enable = true;
            plugins = [
              { name = "z-shell/F-Sy-H"; }
              { name = "jeffreytse/zsh-vi-mode"; }
              { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
              { name = "plugins/fzf"; tags = [ from:oh-my-zsh ]; }
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
          };
        };

        home.packages = with pkgs; [
          bitwarden-cli
          elmPackages.elm-language-server
          fd
          fswatch
          fnlfmt
          neovim
          nodejs-18_x
          ripgrep
          rsync
          wget
        ];
        #home.file.".config/nixpkgs/home/flake.nix".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/flake.nix";
      };
    };
  };
}
