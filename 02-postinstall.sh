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
read USER
zfs create -o mountpoint=/home/${USER} ${POOL}/home/${USER}
useradd -G sudo ${USER}
cp /etc/skel/.bash* /home/${USER}
chmod 700 /home/${USER}
chown -R ${USER}:${USER} /home/${USER}

passwd ${USER}

# Initial configuration is done
echo "Basic OS configuration is complete. Reboot..."

