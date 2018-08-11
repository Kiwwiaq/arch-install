#!/bin/bash
clear

POOL="testpool"

echo "Disks present on the system:"
lsscsi
echo -n "Select a disk: "
read DISK
DISK="/dev/${DISK}"

# Update the system clock
echo "Updating system time..."
timedatectl set-ntp true

# Wipe selected disk, if SSD
#echo "Formating disk ${DISK}..."
# ToDo

# Create partition table
# TRIM not implemented yet
# For HDD and overprovisioned SSD only
echo "Creating partition table on ${DISK}..."
#parted -s -a optimal ${DISK} mklabel gpt
parted -s -a optimal /dev/sda mklabel gpt
parted -s -a optimal /dev/sdb mklabel gpt

# Create ZFS root pool and vdevs
echo "Creating ZFS root pool and vdevs..."
#zpool create -f -O compression=lz4 -O atime=off -O mountpoint=none ${POOL} ${DISK}
zpool create -f -O compression=lz4 -O atime=off -O mountpoint=none ${POOL} /dev/sda /dev/sdb
zfs create -o mountpoint=none ${POOL}/ROOT
zfs create -o mountpoint=/ ${POOL}/ROOT/arch
zfs create -o mountpoint=none ${POOL}/home

# Import ZFS root pool to /mnt
echo "Importing ZFS root pool to /mnt..."
zpool export ${POOL}
zpool import -R /mnt ${POOL}

# Create and mount the ESP partition
echo "Creating and mounting ESP partition ..."
mkfs.vfat ${DISK}9
mkdir -p /mnt/boot/efi
mount ${DISK}9 /mnt/boot/efi

# Create swap space
echo "Creating swap..."
zfs create -V 1G -b 4096 ${POOL}/swap
mkswap -f /dev/zvol/${POOL}/swap
swapon /dev/zvol/${POOL}/swap

# Manage repositories
# Arch repository
echo "Resfreshing package repositories..."
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
#rankmirrors -n 2 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
#echo "Server = https://archive.archlinux.org/repos/2018/08/10/\$repo/os/\$arch/" > /etc/pacman.d/mirrorlist

# Refresh signatures
echo "Refreshing signatures..."
#pacman-key --refresh-keys
#pacman-key -r F75D9D76
#pacman-key --lsign-key F75D9D76


# Refresh repositories
echo "Refreshing repositories..."
pacman -Syy

# Install the base OS
echo "Installing base os..."
pacstrap /mnt base base-devel zfs-linux grub efibootmgr wget git networkmanager

# Generate the fstab file, comment all vdevs except ESP and swap entries, correct the swap entry
echo "Generating /etc/fstab file..."
genfstab -p /mnt >> /mnt/etc/fstab
sed -i "s/^${POOL}/#${POOL}/" /mnt/etc/fstab
sed -i "s/zd0/zvol\/${POOL}\/swap/" /mnt/etc/fstab

# Set hostname
echo "Setting hostname..."
echo "kiwwiaq-pc" > /mnt/etc/hostname

# Set time zone
echo "Setting timezone..."
ln -sf /mnt/usr/share/zoneinfo/Europe/Bratislava /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc

# Generate locale
echo "Generating locale..."
sed -i "s/#en_US.UTF/en_US.UTF/" /mnt/etc/locale.gen
echo "LANG=en.US.UTF-8" > /mnt/etc/locale.conf
arch-chroot /mnt locale-gen

# Set root password
echo "Create root password..."
arch-chroot /mnt passwd

# ZFS ${POOL} boot preparation
echo "Preparing root pool..."
arch-chroot /mnt zpool set cachefile=/etc/zfs/zpool.cache ${POOL}
arch-chroot /mnt zpool set bootfs=${POOL}/ROOT/arch ${POOL}

# Enable neccessary services at startup
echo "Enabling neccessary services at startup..."
arch-chroot /mnt systemctl enable zfs.target
arch-chroot /mnt systemctl enable zfs-mount
arch-chroot /mnt systemctl enable zfs-import-cache
arch-chroot /mnt systemctl enable NetworkManager.service

# Install boot manager to ESP
echo "Installing boot manager..."
arch-chroot /mnt /bin/bash -c "ZPOOL_VDEV_NAME_PATH=1 grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB"
# Generate GRUB config
arch-chroot /mnt /bin/bash -c "ZPOOL_VDEV_NAME_PATH=1 grub-mkconfig -o /boot/grub/grub.cfg"

# Refresh RAM disk
echo "Refreshing RAM disk..."
# Update kernel hooks in /etc/mkinitcpio.conf
sed -i "/^HOOKS=/c HOOKS=\"base udev autodetect modconf block keyboard zfs filesystems\"" /mnt/etc/mkinitcpio.conf
# Create RAM disk
arch-chroot /mnt mkinitcpio -p linux

# Umount and export ${POOL}
echo "Unmounting root pool..."
umount /mnt/boot/efi
swapoff /dev/zvol/${POOL}/swap
zfs umount -a
zpool export ${POOL}

# Installation is done
echo "OS install is complete. Reboot..."

