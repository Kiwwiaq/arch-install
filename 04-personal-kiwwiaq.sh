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

sudo systemctl enable teamviewerd
