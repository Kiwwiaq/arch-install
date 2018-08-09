#!/bin/bash
clear

# Install Xorg and GPU drivers
echo "Installing Xorg..."
pacman --noconfirm --needed -S xorg-server virtualbox-guest-utils
