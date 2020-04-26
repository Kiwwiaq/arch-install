#!/bin/bash
clear

# Install basic GUI
echo "Installing ibasic GUI..."
sudo pacman --noconfirm --needed -S virtualbox-guest-utils xorg-server lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings cinnamon

# Install base software
sudo pacman --noconfirm --needed -S gnome-terminal