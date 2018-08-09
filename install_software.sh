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
makepkg -scri
cd /home/kiwwiaq/pacaur
makepkg -scri

# Install display and window manager 
echo "Installing display and window manager..."
sudo pacman --noconfirm --needed -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings cinnamon

# Accessories category software
echo "Installing Accessories software..."
sudo pacman --noconfirm --needed -S gnome-calculator nautilus gedit gnome-screenshot file-roller
pacaur -S enpass-bin

# Graphics category software
echo "Installing Graphics software..."
sudo pacman --noconfirm --needed -S gtumb

# Internet category software
echo "Installing Internet software..."
sudo pacman --noconfirm --needed -S firefox thunderbird deluge
pacaur -S skypeforlinux-bin

# Office category software
echo "Installing Office software..."
sudo pacman --noconfirm --needed -S libreoffice-fresh evince
pacaur -S hunspell-sk

# Sound & Video category software
echo "Installing Sound & Video software..."
pacman --noconfirm --needed -S rhythmbox 
pacaur -S xplayer

# Administration category software
echo "Installing Administration software..."
pacman --noconfirm --needed -S gnome-terminal guake gnome-disk-utility
pacaur -S

# Codecs
echo "Installing additional codecs..."
pacman --noconfirm --needed -S gst-plugins-ugly gst-plugins-bad gst-libav flac flashplugin
pacaur -S

# Common software
echo "Installing common software..."
pacman --noconfirm --needed -S xdg-utils xdg-user-dirs sane lsscsi ntfs-3g unzip e2fsprogs
pacaur -S systemd-numlockontty nvme-cli 


# Other tools
# gtk: doublecmd-gtk2 gksu
echo "Installing other tools..."
#pacman --noconfirm -S doublecmd-gtk2 gksu

# Fonts
# https://gist.github.com/cryzed/e002e7057435f02cc7894b9e748c5671
#ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
#ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
#https://bbs.archlinux.org/viewtopic.php?id=221915
wget http://kiwwiaq.sk/arch/local.conf -P /etc/fonts/

# Themes
#wget adapta-color-git
#sudo -u kiwwiaq -H sh -c "pacaur -S noto-fonts"

# easytag flacon
# KVM
#sudo -u kiwwiaq -H sh -c "pacaur -S libvirt-zfs ovmf-git"
#pacman --noconfirm -S qemu virt-manager

systemctl enable lightdm.service
systemctl enable numLockOnTty.service

#todo
# pop sound
# hybernation