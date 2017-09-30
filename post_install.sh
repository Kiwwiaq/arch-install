#!/bin/bash
clear

# Create correct hostid
echo "Creating hostid..."
wget http://kiwwiaq.sk/arch/writehostid.c
gcc -o writehostid writehostid.c
./writehostid

# Update zpool.cache
echo "Updating /etc/zfs/zpool.cache file..."
zpool set cachefile=/etc/zfs/zpool.cache rpool

# ??? Refresh RAM disk
echo "Refreshing RAM disk..."
mkinitcpio -p linux

# Setup local time
echo "Setting local time..."
sed -i 's/^#NTP=/NTP=0.cz.pool.ntp.org 1.cz.pool.ntp.org 2.cz.pool.ntp.org 3.cz.pool.ntp.org/' /etc/systemd/timesyncd.conf
sed -i 's/^#FallbackNTP/FallbackNTP/' /etc/systemd/timesyncd.conf
timedatectl set-timezone Europe/Bratislava
timedatectl set-ntp true

# Update sudo groups
echo "Updating sudo groups..."
groupadd sudo
sed -i "s/^# %sudo/%sudo/" /etc/sudoers

# Create user
echo "Creating user..."
echo "Select username: "
read USERNAME
zfs create rpool/home/${USERNAME}
useradd -G sudo ${USERNAME}
cp /etc/skel/.bash* /home/${USERNAME}
chmod 700 /home/${USERNAME}
chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

passwd ${USERNAME}

# Initial configuration is done
echo "Basic OS configuration is complete. Reboot..."
