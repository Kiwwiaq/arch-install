# Sound & Video category software
echo "Installing Sound & Video software..."
pacaur --noconfirm --noedit -S xplayer plex-media-player-git

# Common software
echo "Installing common software..."
sudo pacman --noconfirm --needed -S sane ntfs-3g e2fsprogs 
pacaur --noconfirm --noedit -S systemd-numlockontty

# Codecs
echo "Installing additional codecs..."
sudo pacman --noconfirm --needed -S gst-plugins-ugly gst-plugins-bad gst-libav flac

# Other tools
# gtk: doublecmd-gtk2 gksu
echo "Installing other tools..."
sudo pacman --noconfirm --needed -S android-file-transfer gvfs-mtp gpaste xorg-xrandr pygtk doublec doublecmd-gtk2
pacaur --noconfirm --noedit -S xboxdrv
#pacman --noconfirm -S gksu

# Wine
echo "Installing wine..."
sudo pacman --noconfirm --needed -S wine-staging wine-mono wine_gecko

# Themes
# GTK and Cinnamon themes
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

#todo
# pop sound
# hybernation
