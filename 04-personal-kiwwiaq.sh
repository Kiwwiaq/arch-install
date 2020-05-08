#!/bin/bash
clear

# Administration category software
echo "Installing Administration software..."
sudo pacman --noconfirm --needed -S guake gnome-disk-utility openssh whdd lsscsi
pacaur --noconfirm --noedit -S teamviewer

# Internet category software
echo "Installing Internet software..."
sudo pacman --noconfirm --needed -S deluge discord

# Other tools
echo "Installing other tools..."
sudo pacman --noconfirm --needed -S virtualbox

# Games
echo "Installing games..."
sudo pacman --noconfirm --needed -S lutris

# Enable installed services
sudo systemctl enable teamviewerd

# Copy menu configuration
cp config_files/cinnamon-applications.menu ~/.config/menus/cinnamon-applications.menu
