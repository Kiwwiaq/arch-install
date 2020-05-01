#!/bin/bash
clear

# Install basic GUI
echo "Installing ibasic GUI..."
sudo pacman --noconfirm --needed -S virtualbox-guest-utils xorg-server lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings cinnamon

# Install base software
sudo pacman --noconfirm --needed -S gnome-terminal

# Enable GUI
sudo systemctl enable lightdm.service

# Terminal fix
sudo localectl set-locale LANG="en_US.UTF-8"
sudo /mnt locale-gen
