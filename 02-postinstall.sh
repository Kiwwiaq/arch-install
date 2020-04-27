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

# ZFS repository
printf "[archzfs]\nServer = http://archzfs.com/\$repo/x86_64" >> /etc/pacman.conf
pacman-key -r F75D9D76
pacman-key --lsign-key F75D9D76

# Update sudo groups
echo "Updating sudo groups..."
groupadd sudo
sed -i "s/^# %sudo/%sudo/" /etc/sudoers

# Create user
echo "Creating user..."
echo "Select username: "
read user
zfs create -o mountpoint=/home/${user} ${POOL}/home/${user}
useradd -G sudo ${user}
cp /etc/skel/.bash* /home/${user}
chmod 700 /home/${user}
chown -R ${user}:${user} /home/${user}

passwd ${user}

# Install AUR helper
echo "Installing AUR helper..."
su - ${user} -c 'git clone https://aur.archlinux.org/auracle-git.giti /tmp/auracle-git'
su - ${user} -c 'git clone https://aur.archlinux.org/pacaur.git /tmp/pacaur'
cd /tmp/auracle-git && su - ${user} -c 'makepkg -si'
cd /tmp/pacaur && su - ${user} -c 'makepkg -si'
cd /

# Clone install scripts to user home directory
su - ${user} -c "git clone https://github.com/Kiwwiaq/arch-install /home/${user}/arch-install"

# Cleanup
rm -r /root/arch-install

# Initial configuration is done
echo "Basic OS configuration is complete. Reboot..."

