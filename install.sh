#!/bin/bash

# APT install
sudo apt update
APT_APPS=(
    apt-transport-https
    ca-certificates
    curl
    git
    gnupg
    lsb-release
    ripgrep
    snapd
    wget
    zenity
    zsh
)
for pkg in "${APT_APPS[@]}"; do
    execute "sudo apt-get install -y $pkg" "$pkg"
done

# Snap install
SNAPS=(
    spotify
    bitwarden
    telegram-desktop
    exercism
    'slack --classic'
    vlc
)

for pkg in "${SNAPS[@]}"; do
    execute "sudo snap install $pkg" "$pkg"
done

# environment
sudo ln -s $PWD/.xsessionrc $HOME

# bin
mkdir $HOME/bin
ln -s $PWD/bin/rofi_run $HOME/bin
ln -s $PWD/bin/zcalendar $HOME/bin
ln -s $PWD/bin/update $HOME/bin

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# i3
mkdir $HOME/.config/i3
ln -s $PWD/config/i3/config $HOME/.config/i3/
ln -s $PWD/config/i3/configure_monitors.sh $HOME/.config/i3/
git clone https://github.com/Massolari/i3scripts $HOME/.config/i3/i3scripts

# Kitty
mkdir $HOME/.config/kitty
ln -s $PWD/config/kitty/kitty.conf $HOME/.config/kitty/
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -s $HOME/.local/kitty.app/bin/kitty $HOME/bin/

# zshrc
ln -s $PWD/.zshrc $HOME/
sudo chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Neovim
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
chmod +x nvim.appimage
mv nvim.appimage $HOME/bin/nvim
mkdir $HOME/.config/nvim
ln -s $PWD/config/nvim/init.vim $HOME/.config/nvim/init.vim
ln -s $PWD/config/nvim/init.bundles.vim $HOME/.config/nvim/init.bundles.vim
mkdir $HOME/.config/nvim/lua
ln -s $PWD/config/nvim/lua/eviline.lua $HOME/.config/nvim/lua/
ln -s $PWD/config/nvim/lua/mappings.lua $HOME/.config/nvim/lua/
ln -s $PWD/config/nvim/lua/config.lua $HOME/.config/nvim/lua/

# Elixir language server
curl -fLO https://github.com/elixir-lsp/elixir-ls/releases/latest/download/elixir-ls.zip
unzip elixir-ls.zip -d $HOME/elixir-ls
chmod +x $HOME/elixir-ls/language_server.sh
rm elixir-ls.zip

# Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install yarn

# Yarn global packages
yarn global add \
    elm \
    elm-test \
    elm-format \
    @elm-tooling/elm-language-server \
    typescript \
    typescript-language-server \
    vscode-css-languageserver-bin \
    vscode-html-languageserver-bin \
    vscode-json-languageserver \
    vim-language-server \
    yaml-language-server

