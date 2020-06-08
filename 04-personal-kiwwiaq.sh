#!/bin/bash
clear

# Administration category software
echo "Installing Administration software..."
sudo pacman --noconfirm --needed -S guake gnome-disk-utility openssh lsscsi htop
pacaur --noconfirm --noedit -S teamviewer whdd

# Internet category software
echo "Installing Internet software..."
sudo pacman --noconfirm --needed -S deluge-gtk discord firefox-ublock-origin

# Other tools
echo "Installing other tools..."
sudo pacman --noconfirm --needed -S virtualbox virtualbox-host-modules-arch
pacaur --noconfirm --noedit brother-hlb2080dw

# Games
echo "Installing games..."
sudo pacman --noconfirm --needed -S lutris steam

# Enable installed services
sudo systemctl enable teamviewerd

# Copy menu configuration
mkdir -p ~/.config/menus/
cp config_files/cinnamon-applications.menu ~/.config/menus/cinnamon-applications.menu

# bashrc and CLI colors
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
cp ~/.config_files/kiwwiaq/.bash* ~/

# TODO
# vimrc
