#!/bin/bash
clear

# Install basic GUI
echo "Installing ibasic GUI..."
sudo pacman --noconfirm --needed -S nvidia nvidia-settings lib32-nvidia-utils lib32-vulkan-icd-loader xorg-server lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings cinnamon

# Common software
echo "Installing common software..."
sudo pacman --noconfirm --needed -S vim xdg-utils xdg-user-dirs unzip libunrar gnome-terminal gnome-keyring cups system-config-printer cifs-utils smartmontools dnsutils inetutils
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

# Install MS Windows 10 fonts
git clone https://aur.archlinux.org/ttf-ms-win10.git ~/.cache/pacaur/ttf-ms-win10
cat ~/arch-install-fonts/fonts.tar.gz.part* > ~/.cache/pacaur/ttf-ms-win10/fonts.tar.gz
tar -xf ~/.cache/pacaur/ttf-ms-win10/fonts.tar.gz --directory ~/.cache/pacaur/ttf-ms-win10/
mv ~/.cache/pacaur/ttf-ms-win10/ms_win10_fonts/* ~/.cache/pacaur/ttf-ms-win10/
rmdir ~/.cache/pacaur/ttf-ms-win10/ms_win10_fonts
cd ~/.cache/pacaur/ttf-ms-win10/; makepkg -si --noconfirm --needed
fc-cache -f

# Enable services
sudo systemctl enable lightdm.service
sudo systemctl enable org.cups.cupsd.socket

# Terminal fix
sudo localectl set-locale LANG="en_US.UTF-8"
sudo locale-gen

# Set administration access
echo -e "polkit.addAdminRule(function(action, subject) {\n\treturn [\"unix-group:wheel\"];\n});" | sudo tee /etc/polkit-1/rules.d/50-default.rules > /dev/null

# Set themes
gsettings set org.cinnamon.theme name 'Adapta-LightGreen'
gsettings set org.cinnamon.desktop.interface gtk-theme 'Adapta-LightGreen'
gsettings set org.cinnamon.desktop.wm.preferences theme 'Adapta-LightGreen'
gsettings set org.cinnamon.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/Icetwigs.jpg'
echo -e "[greeter]\ntheme-name = Adapta-LightGreen-Eta" | sudo tee /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null

# Other settings
gsettings set org.gnome.Terminal.Legacy.Settings headerbar true
mkdir -p ~/Pictures/Screenshot
gsettings set org.gnome.gnome-screenshot auto-save-directory "file:///home/$USER/Pictures/Screenshot/"

