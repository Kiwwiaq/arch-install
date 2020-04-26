#!/bin/bash
clear

echo "Updating system time..."
timedatectl set-timezone Europe/Bratislava
timedatectl set-ntp true

echo "Creating new partition table on virtual disk..."
parted -s -a optimal /dev/sda mklabel gpt

echo "Creating ZFS root pool and vdevs..."
zpool create -f -O compression=lz4 -O atime=off -O mountpoint=none rpool /dev/sda
zfs create -o mountpoint=none rpool/ROOT
zfs create -o mountpoint=/ rpool/ROOT/arch
zfs create -o mountpoint=none rpool/home

echo "Exporting rpool..."
zpool export rpool

echo "Importing ZFS root pool to /mnt..."
zpool import -R /mnt rpool

echo "Creating and mounting ESP partition ..."
mkfs.vfat /dev/sda9
fatlabel /dev/sda9 EFI
mkdir -p /mnt/boot/efi
mount /dev/sda9 /mnt/boot/efi

echo "Creating swap..."
zfs create -V 1G -b 4096 rpool/swap
mkswap -f /dev/zvol/rpool/swap
swapon /dev/zvol/rpool/swap

echo "Resfreshing package repositories..."
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
#rankmirrors -n 2 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
#echo "Server = https://archive.archlinux.org/repos/2019/12/17/\$repo/os/\$arch/" > /etc/pacman.d/mirrorlist

echo "Refreshing signatures..."
pacman-key --refresh-keys

echo "Refreshing repositories..."
pacman -Syy

echo "Installing base os..."
pacstrap /mnt base base-devel archzfs-linux grub efibootmgr wget git networkmanager

echo "Generating /etc/fstab file..."
genfstab -p /mnt >> /mnt/etc/fstab
sed -i "s/^rpool/#rpool/" /mnt/etc/fstab
sed -i "s/zd0/zvol\/rpool\/swap/" /mnt/etc/fstab

echo "Setting hostname..."
echo "kiwwiaq-pc" > /mnt/etc/hostname

echo "Setting timezone..."
ln -sf /mnt/usr/share/zoneinfo/Europe/Bratislava /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc

echo "Generating locale..."
sed -i "s/#en_US.UTF/en_US.UTF/" /mnt/etc/locale.gen
echo "LANG=en.US.UTF-8" > /mnt/etc/locale.conf
arch-chroot /mnt locale-gen

echo "Create root password..."
arch-chroot /mnt passwd

echo "Preparing root pool..."
arch-chroot /mnt zpool set cachefile=/etc/zfs/zpool.cache rpool
arch-chroot /mnt zpool set bootfs=rpool/ROOT/arch rpool

echo "Enabling neccessary services at startup..."
arch-chroot /mnt systemctl enable zfs-import-cache
arch-chroot /mnt systemctl enable zfs-import.target
arch-chroot /mnt systemctl enable zfs-mount
arch-chroot /mnt systemctl enable zfs.target
arch-chroot /mnt systemctl enable NetworkManager.service

echo "Installing boot manager..."
arch-chroot /mnt /bin/bash -c "ZPOOL_VDEV_NAME_PATH=1 grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB"
arch-chroot /mnt /bin/bash -c "ZPOOL_VDEV_NAME_PATH=1 grub-mkconfig -o /boot/grub/grub.cfg"

echo "Refreshing RAM disk..."
sed -i "/^HOOKS=/c HOOKS=\"base udev autodetect modconf block keyboard zfs filesystems\"" /mnt/etc/mkinitcpio.conf
arch-chroot /mnt mkinitcpio -p linux

echo "Unmounting root pool..."
umount /mnt/boot/efi
swapoff /dev/zvol/rpool/swap
zfs umount -a
zpool export rpool

echo "Base OS install is complete. Reboot to OS..."

