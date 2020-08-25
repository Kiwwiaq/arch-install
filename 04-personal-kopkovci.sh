#!/bin/bash
clear

# Administration category software
echo "Installing Administration software..."
sudo pacman --noconfirm --needed -S openssh lsscsi htop gnome-disk-utility
pacaur --noconfirm --noedit -S teamviewer

# Internet category software
echo "Installing Internet software..."
sudo pacman --noconfirm --needed -S firefox-ublock-origin thunderbird-i18n-sk firefox-i18n-sk

# Other tools
echo "Installing other tools..."
sudo pacman --noconfirm --needed -S pitivi
#pacaur --noconfirm --noedit 

# Games
#echo "Installing games..."
#sudo pacman --noconfirm --needed -S lutris steam
#pacaur --noconfirm --noedit proton-ge-custom-bin winetricks

# Localization
echo "Installing Slovac localization..."
#sed -i "s/#sk_SK.UTF-8/sk_SK.UTF-8/" /mnt/etc/locale.gen
#arch-chroot /mnt localectl set-locale LANG="sk_SK.UTF-8"
#arch-chroot /mnt locale-gen
sudo pacman --noconfirm --needed -S cinnamon-translations
pacaur --noconfirm --noedit mintlocale
xdg-user-dirs-update --force

# Enable installed services
sudo systemctl enable teamviewerd

# Copy menu configuration
mkdir -p ~/.config/menus/
cp config_files/cinnamon-applications.menu ~/.config/menus/cinnamon-applications.menu

# bashrc and CLI colors
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
#cp ~/.config_files/kiwwiaq/.bash* ~/

# TODO
# vimrc
