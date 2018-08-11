#!/bin/bash
clear

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
parted -s -a optimal ${DISK} mklabel gpt

# Create ZFS root pool and vdevs
echo "Creating ZFS root pool and vdevs..."
#zpool create -f -O compression=lz4 -O atime=off -O mountpoint=none testpool ${DISK}
#zpool create -f -o feature@async_destroy=disabled -o feature@empty_bpobj=disabled -o feature@lz4_compress=disabled -o feature@multi_vdev_crash_dump=disabled -o feature@spacemap_histogram=disabled -o feature@enabled_txg=disabled -o feature@hole_birth=disabled -o feature@extensible_dataset=disabled -o feature@embedded_data=disabled -o feature@bookmarks=disabled -o feature@filesystem_limits=disabled -o feature@large_blocks=disabled -o feature@large_dnode=disabled -o feature@sha512=disabled -o feature@skein=disabled -o feature@edonr=disabled -o feature@userobj_accounting=disabled -O mountpoint=none testpool ${DISK}
zpool create -f -O compression=lz4 -O atime=off -O mountpoint=none testpool ${DISK}
zfs create -o mountpoint=none testpool/ROOT
zfs create -o mountpoint=/ testpool/ROOT/arch
zfs create -o mountpoint=none testpool/home

# Import ZFS root pool to /mnt
echo "Importing ZFS root pool to /mnt..."
zpool export testpool
zpool import -R /mnt testpool

# Create and mount the ESP partition
echo "Creating and mounting ESP partition ..."
mkfs.vfat ${DISK}9
mkdir -p /mnt/boot/efi
mount ${DISK}9 /mnt/boot/efi

# Create swap space
echo "Creating swap..."
zfs create -V 1G -b 4096 testpool/swap
mkswap -f /dev/zvol/testpool/swap
swapon /dev/zvol/testpool/swap

# Manage repositories
# Arch repository
echo "Resfreshing package repositories..."
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
#rankmirrors -n 2 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
echo "Server = https://archive.archlinux.org/repos/2018/08/10/\$repo/os/\$arch/" > /etc/pacman.d/mirrorlist
# ZFS repository
#printf "[archzfs]\nServer = http://archzfs.com/\$repo/x86_64" >> /etc/pacman.conf

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
pacstrap /mnt base base-devel zfs-linux refind-efi wget git networkmanager
#pacstrap /mnt base base-devel zfs-linux grub efibootmgr wget git networkmanager

# Generate the fstab file, comment all vdevs except ESP and swap entries, correct the swap entry
echo "Generating /etc/fstab file..."
genfstab -p /mnt >> /mnt/etc/fstab
sed -i "s/^testpool/#testpool/" /mnt/etc/fstab
sed -i "s/zd0/zvol\/testpool\/swap/" /mnt/etc/fstab

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

# ZFS testpool boot preparation
echo "Preparing root pool..."
arch-chroot /mnt zpool set cachefile=/etc/zfs/zpool.cache testpool
arch-chroot /mnt zpool set bootfs=testpool/ROOT/arch testpool

# Enable neccessary services at startup
echo "Enabling neccessary services at startup..."
arch-chroot /mnt systemctl enable zfs.target
arch-chroot /mnt systemctl enable zfs-mount
arch-chroot /mnt systemctl enable zfs-import-cache
arch-chroot /mnt systemctl enable NetworkManager.service

# Install boot manager to ESP
echo "Installing boot manager..."
arch-chroot /mnt refind-install
#arch-chroot /mnt ZPOOL_VDEV_NAME_PATH=1 grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
# Get ZFS driver for UEFI to recognize ZFS dataset - from http://efi.akeo.ie/
mkdir -p /mnt/boot/efi/EFI/refind/drivers_x64/k
mkdir -p /mnt/boot/efi/EFI/refind/drivers_x64/1
mkdir -p /mnt/boot/efi/EFI/refind/drivers_x64/11
mkdir -p /mnt/boot/efi/EFI/refind/drivers_x64/12
mkdir -p /mnt/boot/efi/EFI/refind/drivers_x64/13
wget http://kiwwiaq.sk/arch/zfs_x64.efi -P /mnt/boot/efi/EFI/refind/drivers_x64/k
wget http://efi.akeo.ie/downloads/efifs-1.0/x64/zfs_x64.efi -P /mnt/boot/efi/EFI/refind/drivers_x64/1
wget http://efi.akeo.ie/downloads/efifs-1.1/x64/zfs_x64.efi -P /mnt/boot/efi/EFI/refind/drivers_x64/11
wget http://efi.akeo.ie/downloads/efifs-1.2/x64/zfs_x64.efi -P /mnt/boot/efi/EFI/refind/drivers_x64/12
wget http://efi.akeo.ie/downloads/efifs-1.3/x64/zfs_x64.efi -P /mnt/boot/efi/EFI/refind/drivers_x64/13
wget http://efi.akeo.ie/downloads/efifs-latest/x64/zfs_x64.efi -P /mnt/boot/efi/EFI/refind/drivers_x64/
# Add dirrectory to auto scan list for automatic menu creation
sed -i "/^#also_scan_dirs/a also_scan_dirs +,/ROOT/arch/@/boot" /mnt/boot/efi/EFI/refind/refind.conf
# Update auto menu entry
printf "\"Boot with standard options\"\t\"rw zfs=bootfs\"\n\"Boot to single-user mode\"\t\"rw zfs=bootfs single\"" > /mnt/boot/refind_linux.conf
# Generate GRUB config
#arch-chroot /mnt ZPOOL_VDEV_NAME_PATH=1 grub-mkconfig -o /boot/grub/grub.cfg

# Refresh RAM disk
echo "Refreshing RAM disk..."
# Update kernel hooks in /etc/mkinitcpio.conf
sed -i "/^HOOKS=/c HOOKS=\"base udev autodetect modconf block keyboard zfs filesystems\"" /mnt/etc/mkinitcpio.conf
# Create RAM disk
arch-chroot /mnt mkinitcpio -p linux

# Umount and export testpool
echo "Unmounting root pool..."
umount /mnt/boot/efi
swapoff /dev/zvol/testpool/swap
zfs umount -a
zpool export testpool

# Installation is done
echo "OS install is complete. Reboot..."

