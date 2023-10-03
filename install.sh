#!/bin/bash

# Pacstrap and setup Arch Linux ARM

CONF_DIR="conf"
SKEL_DIR="skel"
PKGS_DIR="pkgs"

MOUNT="/mnt"

# ASSUMPTIONS
# 1. Target disk has been partitioned with fdisk
# 2. Filesystems have been created
# 3. Filesystems are mounted at /mnt and /mnt/boot

# Start binfmt QEMU arm service
sudo systemctl start systemd-binfmt.service

PACSTRAP="sudo pacstrap -MKC $CONF_DIR/pacman.conf $MOUNT"
CHROOT="sudo arch-chroot $MOUNT"

# Basic setup
$PACSTRAP base archlinuxarm-keyring

# Disable future initramfs builds
STOP_INITRAMFS="raspberrypi-stop-initramfs-4-1-any.pkg.tar.xz"
STOP_INITRAMFS_PKG="$PKGS_DIR/$STOP_INITRAMFS"
sudo cp -f "$STOP_INITRAMFS_PKG" $MOUNT/root
$CHROOT pacman -U /root/$STOP_INITRAMFS --noconfirm

# Install kernel and bootloader
$PACSTRAP linux-rpi raspberrypi-bootloader

# Install essential packages
PKGS="sudo openssh neofetch htop vim less bash-completion"
$PACSTRAP $PKGS

# Enable services
$CHROOT systemctl enable sshd.service
$CHROOT systemctl enable systemd-timesyncd.service
$CHROOT systemctl enable systemd-resolved.service
$CHROOT systemctl enable systemd-networkd.service

# resolv.conf
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf

# networkd
sudo cp $CONF_DIR/ethernet.network $MOUNT/etc/systemd/network

# Timezone
$CHROOT ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

# sudoers config
sudo cp -f $CONF_DIR/wheel          $MOUNT/etc/sudoers.d

# fstab
sudo cp -f $CONF_DIR/fstab          $MOUNT/etc

# Bootloader config
sudo cp -f $CONF_DIR/cmdline.txt    $MOUNT/boot
sudo cp -f $CONF_DIR/config.txt     $MOUNT/boot

# Dotfiles
sudo cp -f $SKEL_DIR/.vimrc         $MOUNT/etc/skel
sudo cp -f $SKEL_DIR/.bashrc        $MOUNT/etc/skel
sudo cp -f $SKEL_DIR/.bash_aliases  $MOUNT/etc/skel

# Locale
echo "en_US.UTF-8 UTF-8" | sudo tee /mnt/etc/locale.gen
echo "LANG=en_US.UTF-8" | sudo tee /mnt/etc/locale.conf
$CHROOT locale-gen

# SSH Keypair
KEY_NAME="arch-key"
ssh-keygen -t ed25519 -f $KEY_NAME -N ''
sudo mkdir -p /mnt/root/.ssh
sudo cp ${KEY_NAME}.pub /mnt/root/.ssh/authorized_keys

# Hostname
sudo cp $CONF_DIR/hostname /mnt/etc/hostname

# Clear pacman cache
$CHROOT rm -rf /var/cache/pacman/pkg
