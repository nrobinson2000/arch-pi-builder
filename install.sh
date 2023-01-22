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

$PACSTRAP base archlinuxarm-keyring linux-rpi raspberrypi-bootloader

# Disable initramfs
        
STOP_INITRAMFS="raspberrypi-stop-initramfs-4-1-aarch64.pkg.tar.xz"
STOP_INITRAMFS_PKG="$PKGS_DIR/$STOP_INITRAMFS"

sudo cp -f "$STOP_INITRAMFS_PKG" $MOUNT/root
$CHROOT pacman -U /root/$STOP_INITRAMFS --noconfirm

# Install essential packages

PKGS="sudo dhcpcd openssh nss-mdns neofetch htop vim"
$PACSTRAP $PKGS

# Enable services

$CHROOT systemctl enable dhcpcd.service
$CHROOT systemctl enable sshd.service
$CHROOT systemctl enable avahi-daemon.service
$CHROOT systemctl enable systemd-timesyncd.service


# Timezone
$CHROOT ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

# sudoers config
sudo cp -f $CONF_DIR/wheel          $MOUNT/etc/sudoers.d

# MDNS config
sudo cp -f $CONF_DIR/nsswitch.conf  $MOUNT/etc

# fstab
sudo cp -f $CONF_DIR/fstab          $MOUNT/etc

# Bootloader config
sudo cp -f $CONF_DIR/cmdline.txt    $MOUNT/boot
sudo cp -f $CONF_DIR/config.txt     $MOUNT/boot

# Dotfiles
sudo cp -f $SKEL_DIR/.vimrc         $MOUNT/etc/skel
sudo cp -f $SKEL_DIR/.bashrc        $MOUNT/etc/skel
sudo cp -f $SKEL_DIR/.bash_aliases  $MOUNT/etc/skel

