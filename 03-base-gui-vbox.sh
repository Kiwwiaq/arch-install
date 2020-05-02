#!/bin/bash
clear

# Install basic GUI
echo "Installing ibasic GUI..."
sudo pacman --noconfirm --needed -S virtualbox-guest-utils xf86-video-vmware xorg-server lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings cinnamon

# Common software
echo "Installing common software..."
sudo pacman --noconfirm --needed -S xdg-utils xdg-user-dirs unzip libunrar gnome-terminal

# Accessories category software
echo "Installing Accessories software..."
sudo pacman --noconfirm --needed -S gnome-calculator nautilus gedit gnome-screenshot file-roller gnome-todo

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
sudo pacman --noconfirm --needed -S rhythmbox

# Administration category software
echo "Installing Administration software..."

# Enable GUI
sudo systemctl enable lightdm.service

# Terminal fix
sudo localectl set-locale LANG="en_US.UTF-8"
sudo locale-gen

