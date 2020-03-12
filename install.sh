#!/bin/sh

# This script is made specifically for my personal linux setup
# By Henry J Son ( @sonbyj01 )
# Updated: March 12th, 2020

# Things that are installed
#     -zsh
#     -tmux
#     -wget
#     -git
#     -vim
#     -vscode
#     -oh-my-zsh

# requires password only once
stty -echo
read -p "Enter password: " password
stty echo

# checks for updates, followed by doing upgrades, and then installing applications
echo $password | sudo -S apt update && sudo apt dist-upgrade -y && sudo apt install zsh tmux wget git vim -y

# removes current configurations and installs my own
cd ~
rm -rf .oh-my-zsh .zsh .vimrc .tmux.conf
wget https://raw.githubusercontent.com/sonbyj01/dotfiles/master/.vimrc
wget https://raw.githubusercontent.com/sonbyj01/dotfiles/master/.tmux.conf

# installs oh-my-zsh
echo $password | sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y

# installs vscode
sudo apt install software-properties-common apt-transport-https -y
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
echo | sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update 
sudo apt install code -y

# sets up git
git config --global user.email "sonbyj01@gmail.com"
git config --global user.name "BY Son"