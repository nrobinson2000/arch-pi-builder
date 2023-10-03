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
$PACSTRAP base

# Disable initramfs
STOP_INITRAMFS="raspberrypi-stop-initramfs-4-1-any.pkg.tar.xz"
STOP_INITRAMFS_PKG="$PKGS_DIR/$STOP_INITRAMFS"
sudo cp -f "$STOP_INITRAMFS_PKG" $MOUNT/root
$CHROOT pacman -U /root/$STOP_INITRAMFS --noconfirm

# Install kernel and bootloader
$PACSTRAP linux-rpi raspberrypi-bootloader

# Install essential packages
PKGS="sudo openssh neofetch htop vim"
$PACSTRAP $PKGS

# Enable services
$CHROOT systemctl enable sshd.service
$CHROOT systemctl enable systemd-timesyncd.service
$CHROOT systemctl enable systemd-resolved.service
$CHROOT systemctl enable systemd-networkd.service

# resolv.conf
$CHROOT ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

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
