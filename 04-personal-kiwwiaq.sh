#!/bin/bash
clear

# Administration category software
echo "Installing Administration software..."
sudo pacman --noconfirm --needed -S guake gnome-disk-utility openssh lsscsi
pacaur --noconfirm --noedit -S teamviewer whdd

# Internet category software
echo "Installing Internet software..."
sudo pacman --noconfirm --needed -S deluge-gtk discord

# Other tools
echo "Installing other tools..."
sudo pacman --noconfirm --needed -S virtualbox
pacaur --noconfirm --noedit brother-hlb2080dw

# Games
echo "Installing games..."
sudo pacman --noconfirm --needed -S lutris steam

# Enable installed services
sudo systemctl enable teamviewerd

# Copy menu configuration
mkdir -p ~/.config/menus/
cp config_files/cinnamon-applications.menu ~/.config/menus/cinnamon-applications.menu
