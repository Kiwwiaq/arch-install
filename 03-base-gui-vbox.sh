#!/bin/bash
clear

# Install basic GUI
echo "Installing ibasic GUI..."
pacman --noconfirm --needed -S virtualbox-guest-utils xorg-server lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings cinnamon

# Install base software
pacman --noconfirm --needed -S gnome-terminal

# Enable GUI
systemctl enable lightdm.service

# Gnome terminal fix
sudo locale-gen
sudo localectl set-locale LANG="en_US.UTF-8"
