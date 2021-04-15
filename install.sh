#!/bin/bash

mkdir $HOME/.config/i3
ln -s $PWD/config/i3/config $HOME/.config/i3/
ln -s $PWD/config/i3/configure_monitors.sh $HOME/.config/i3/
git clone https://github.com/Massolari/i3scripts $HOME/.config/i3/i3scripts

mkdir $HOME/.config/kitty
ln -s $PWD/config/kitty/kitty.conf $HOME/.config/kitty/

ln -s $PWD/.zshrc $HOME/

mkdir $HOME/.config/nvim
ln -s $PWD/config/nvim/init.vim $HOME/.config/nvim/init.vim
ln -s $PWD/config/nvim/init.bundles.vim $HOME/.config/nvim/init.bundles.vim
