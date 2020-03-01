#!/bin/sh

# This script is made specifically for the laptops used in the Makerspace
# By Henry J Son ( @sonbyj01 ) 
# Updated: February 29th, 2020

# will check for updates, upgrade if necessary, and then install zsh tmux wget
sudo apt update && sudo apt dist-upgrade -y && sudo apt install zsh tmux wget

# will install ohmyzsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y

# will install vscode
sudo apt install software-properties-common apt-transport-https
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update 
sudo apt install vscode -y

# will download configuration files from @sonbyj01 's github
cd ~
rm -rf .oh-my-zsh .zsh .vimrc .tmux.conf
wget https://raw.githubusercontent.com/sonbyj01/dotfiles/master/.vimrc
wget https://raw.githubusercontent.com/sonbyj01/dotfiles/master/.tmux.conf

# will attempt to save battery life
sudo apt-add-repository ppa:linrunner/tlp
sudo apt update
sudo apt install tlp tlp-rdw -y
sudo tlp start

# will activate two finger scrolling
sudo apt remove xserver-xorg-input-libinput libinput-tools
sudo apt install xserver-xorg-input-all xserver-xorg-input-evdev xserver-xorg-input-synaptics -y
synclient VertTwoFingerScroll=1

# will enable natural scrolling
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true

# will enable tap-to-click
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

exit 0
