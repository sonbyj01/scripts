#!/bin/bash

# This script is for my old computers that I'm reusing as servers
# By Henry J Son ( @sonbyj01 )
# Updated: March 26th, 2020

# gets network information
read -p "Connection name: " NAME
read -p "Static IP Address: " ADDRESS
read -p "Gateway: " GATEWAY
read -p "Network: " NETWORK
read -p "Broadcast: " BROADCAST
read -p "Subnet Mask: " MASK
read -p "Nameservers: " DNS

# requires password only once 
stty -echo
read -p "Make sure you are a sudoer\nEnter password: " password
stty echo

# checks for updates and applies those upgrades
echo $password | sudo -S apt update && sudo apt dist-upgrade -y

# installs some applications
sudo apt install zsh tmux wget vim htop net-tools ufw git resolvconf -y

# configure ufw
sudo ufw disable
sudo ufw allow 31415
echo 'y' | sudo ufw enable
sudo ufw reload 

# enable port 31415 for ssh
echo "Port 31415" | sudo tee -a /etc/ssh/sshd_config

# disables NetworkManager
sudo systemctl stop NetworkManager.service
sudo systemctl disable NetworkManager.service

# gives server static ip address
echo "auto $NAME\nallow-hotplug $NAME\niface $NAME inet static\n\taddress $ADDRESS\n\tnetmask $MASK\n\tnetwork $NETWORK\n\tbroadcast $BROADCAST\n\tgateway $GATEWAY\n\t dns-nameservers $DNS 8.8.8.8" | sudo tee -a /etc/network/interfaces 

# restarts network
sudo systemctl restart networking.service
sudo systemctl restart resolvconf.service

# removes current configurations and installs personal one
cd ~
rm -rf .oh-my-zsh .zsh .vimrc .tmux.conf
wget https://raw.githubusercontent.com/sonbyj01/dotfiles/master/.vimrc
wget https://raw.githubusercontent.com/sonbyj01/dotfiles/master/.tmux.conf

# installs oh-my-zsh
echo $password | sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y

# changes shell
sudo chsh -s /bin/zsh root
sudo chsh -s /bin/zsh "$USER"

# installs speed test and runs it 
wget https://raw.githubusercontent.com/sonbyj01/scripts/master/speedtest.sh
chmod +x speedtest.sh
./speedtest.sh

# restarts computer
sudo reboot
