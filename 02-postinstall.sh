#!/bin/bash
clear

POOL="rpool"

# Create hostid
echo "Creating hostid..."
zgenhostid $(hostid)

# Update zpool.cache
echo "Updating /etc/zfs/zpool.cache file..."
zpool set cachefile=/etc/zfs/zpool.cache ${POOL}

# Refresh RAM disk
echo "Refreshing RAM disk..."
mkinitcpio -p linux

# Setup local time
echo "Setting local time..."
sed -i 's/^#NTP=/NTP=0.cz.pool.ntp.org 1.cz.pool.ntp.org 2.cz.pool.ntp.org 3.cz.pool.ntp.org/' /etc/systemd/timesyncd.conf
sed -i 's/^#FallbackNTP/FallbackNTP/' /etc/systemd/timesyncd.conf
timedatectl set-timezone Europe/Bratislava
timedatectl set-ntp true

# Update repositories
printf "[archzfs]\nServer = http://archzfs.com/\$repo/x86_64\n" >> /etc/pacman.conf
pacman-key -r F75D9D76
pacman-key --lsign-key F75D9D76
printf "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" >> /etc/pacman.conf
pacman -Syy

# Update sudo groups
echo "Updating sudo groups..."
sed -i "s/^# %wheel/%wheel/" /etc/sudoers

# Create user
echo "Creating user..."
echo "Select username: "
read user
zfs create -o mountpoint=/home/${user} ${POOL}/home/${user}
useradd -d /home/${user} -G wheel ${user}
cp /etc/skel/.bash* /home/${user}
chmod 700 /home/${user}
chown -R ${user}:${user} /home/${user}

passwd ${user}

# Install AUR helper
echo "Installing AUR helper..."
sudo -u ${user} git clone https://aur.archlinux.org/auracle-git.git /tmp/auracle-git
sudo -u ${user} git clone https://aur.archlinux.org/pacaur.git /tmp/pacaur
cd /tmp/auracle-git; sudo -u ${user} makepkg -si --noconfirm --needed
cd /tmp/pacaur; sudo -u ${user} makepkg -si --noconfirm --needed

# Clone install scripts to user home directory
sudo -u ${user} git clone https://github.com/Kiwwiaq/arch-install /home/${user}/arch-install
sudo -u ${user} git clone https://github.com/Kiwwiaq/arch-install-fonts /home/${user}/arch-install-fonts

# Cleanup
rm -r /root/arch-install

# Optimize multicore compilation
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j\$\(nproc\)\"/" /etc/makepkg.conf

# Initial configuration is done
echo "Basic OS configuration is complete. Reboot..."

