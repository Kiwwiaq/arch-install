#!/bin/bash
clear

# Install basic GUI
echo "Installing ibasic GUI..."
sudo pacman --noconfirm --needed -S virtualbox-guest-utils xf86-video-vmware xorg-server lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings cinnamon

# Common software
echo "Installing common software..."
sudo pacman --noconfirm --needed -S vi vim xdg-utils xdg-user-dirs unzip libunrar gnome-terminal gnome-keyring cups system-config-printer
pacaur --noconfirm --noedit -S vi-vim-symlink

# Eyecandy
pacaur --noconfirm --noedit -S adapta-gtk-theme-colorpack

# Accessories category software
echo "Installing Accessories software..."
sudo pacman --noconfirm --needed -S gnome-calculator nautilus gedit gnome-screenshot file-roller gnome-todo brasero

# Graphics category software
echo "Installing Graphics software..."
sudo pacman --noconfirm --needed -S gthumb

# Internet category software
echo "Installing Internet software..."
sudo pacman --noconfirm --needed -S firefox thunderbird
pacaur --noconfirm --noedit -S skypeforlinux-stable-bin

# Office category software
echo "Installing Office software..."
sudo pacman --noconfirm --needed -S libreoffice-fresh evince
pacaur --noconfirm --noedit -S hunspell-sk

# Audio & Video category software
echo "Installing Sound & Video software..."
sudo pacman --noconfirm --needed -S lollypop totem

# Enable services
sudo systemctl enable lightdm.service
sudo systemctl enable org.cups.cupsd.service

# Terminal fix
sudo localectl set-locale LANG="en_US.UTF-8"
sudo locale-gen

# Set themes
gsettings set org.cinnamon.theme name 'Adapta-LightGreen'
gsettings set org.cinnamon.desktop.interface gtk-theme 'Adapta-LightGreen'
gsettings set org.cinnamon.desktop.wm.preferences theme 'Adapta-LightGreen'
gsettings set org.cinnamon.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/Icetwigs.jpg'
echo -e "[greeter]\ntheme-name = Adapta-LightGreen-Eta" | sudo tee /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null
gsettings set org.gnome.Terminal.Legacy.Settings headerbar true
