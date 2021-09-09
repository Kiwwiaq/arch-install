#!/bin/bash
clear

# Administration category software
echo "Installing Administration software..."
sudo pacman --noconfirm --needed -S guake gnome-disk-utility openssh lsscsi htop
pacaur --noconfirm --noedit -S teamviewer whdd

# Internet category software
echo "Installing Internet software..."
sudo pacman --noconfirm --needed -S deluge-gtk discord firefox-ublock-origin firefox-extension-bitwarden nmap

# Other tools
echo "Installing other tools..."
sudo pacman --noconfirm --needed -S virtualbox virtualbox-host-modules-arch
pacaur --noconfirm --noedit brother-hlb2080dw

# Games
echo "Installing games..."
sudo pacman --noconfirm --needed -S lutris steam
pacaur --noconfirm --noedit proton-ge-custom-bin winetricks

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

# Batthe.NET dependencies
sudo pacman --noconfirm --needed -S lib32-gnutls lib32-libldap lib32-libgpg-error lib32-sqlite lib32-libpulse

# Wine dependencies
sudo pacman --noconfirm --needed -S giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
