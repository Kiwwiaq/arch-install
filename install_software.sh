#!/bin/bash

# Install AUR helper
echo "Installing AUR helper..."
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
cd /home/kiwwiaq
wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
tar -zxvf cower.tar.gz
tar -zxvf pacaur.tar.gz
cd /home/kiwwiaq/cower
makepkg --noconfirm -scri
cd /home/kiwwiaq/pacaur
makepkg --noconfirm -scri

# Install display and window manager 
echo "Installing display and window manager..."
sudo pacman --noconfirm --needed -S xorg-server lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings cinnamon

# Accessories category software
echo "Installing Accessories software..."
sudo pacman --noconfirm --needed -S gnome-calculator nautilus gedit gnome-screenshot file-roller
pacaur --noconfirm --noedit -S enpass-bin

# Graphics category software
echo "Installing Graphics software..."
sudo pacman --noconfirm --needed -S gthumb

# Internet category software
echo "Installing Internet software..."
sudo pacman --noconfirm --needed -S firefox thunderbird deluge
pacaur --noconfirm --noedit -S skypeforlinux-bin

# Office category software
echo "Installing Office software..."
sudo pacman --noconfirm --needed -S libreoffice-fresh evince
pacaur --noconfirm --noedit -S hunspell-sk

# Sound & Video category software
echo "Installing Sound & Video software..."
sudo pacman --noconfirm --needed -S rhythmbox 
pacaur --noconfirm --noedit -S xplayer plex-media-player-git

# Administration category software
echo "Installing Administration software..."
sudo pacman --noconfirm --needed -S gnome-terminal guake gnome-disk-utility

# Codecs
echo "Installing additional codecs..."
sudo pacman --noconfirm --needed -S gst-plugins-ugly gst-plugins-bad gst-libav flac

# Common software
echo "Installing common software..."
sudo pacman --noconfirm --needed -S xdg-utils xdg-user-dirs sane lsscsi ntfs-3g unzip e2fsprogs
pacaur --noconfirm --noedit -S systemd-numlockontty nvme-cli 


# Other tools
# gtk: doublecmd-gtk2 gksu
echo "Installing other tools..."
#pacman --noconfirm -S doublecmd-gtk2 gksu

# Themes
# GTK and Cinnamon themes
# https://github.com/ivan-krasilnikov/adapta-gtk-theme-colorpack# Icons
#sudo pacman --noconfirm --needed -S papirus-icon-theme
# Fonts
#ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
#ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
#sudo wget http://kiwwiaq.sk/arch/local.conf -P /etc/fonts/
# https://bbs.archlinux.org/viewtopic.php?id=221915
# https://gist.github.com/cryzed/e002e7057435f02cc7894b9e748c5671
#sudo -u kiwwiaq -H sh -c "pacaur -S noto-fonts"

# easytag flacon

# KVM
#sudo -u kiwwiaq -H sh -c "pacaur -S libvirt-zfs ovmf-git"
#pacman --noconfirm -S qemu virt-manager

sudo systemctl enable lightdm.service
sudo systemctl enable numLockOnTty.service

# Gnome terminal fix
sudo locale-gen
sudo localectl set-locale LANG="en_US.UTF-8"

#todo
# pop sound
# hybernation
