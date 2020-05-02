# Internet category software
echo "Installing Internet software..."
sudo pacman --noconfirm --needed -S deluge

# Sound & Video category software
echo "Installing Sound & Video software..."
pacaur --noconfirm --noedit -S xplayer plex-media-player-git

# Administration category software
echo "Installing Administration software..."
sudo pacman --noconfirm --needed -S guake gnome-disk-utility

# Common software
echo "Installing common software..."
sudo pacman --noconfirm --needed -S sane lsscsi ntfs-3g e2fsprogs openssh 

# Other tools
# gtk: doublecmd-gtk2 gksu
echo "Installing other tools..."
sudo pacman --noconfirm --needed -S virtualbox android-file-transfer gvfs-mtp gpaste xorg-xrandr gnome-keyring pygtk doublec doublecmd-gtk2
pacaur --noconfirm --noedit -S teamviewer discord xboxdrv
#pacman --noconfirm -S gksu
#pacaur --noconfirm --noedit -S whdd

# Wine
echo "Installing wine..."
sudo pacman --noconfirm --needed -S wine-staging wine-mono wine_gecko

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

sudo systemctl enable numLockOnTty.service
sudo systemctl enable teamviewerd

# Gnome terminal fix
sudo locale-gen
sudo localectl set-locale LANG="en_US.UTF-8"

#todo
# pop sound
# hybernation
