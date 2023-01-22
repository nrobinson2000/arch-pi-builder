#!/bin/bash

# Pacstrap and setup Arch Linux ARM

# ASSUMPTIONS
# 1. Target disk has been partitioned with fdisk
# 2. Filesystems have been created
# 3. Filesystems are mounted at /mnt and /mnt/boot

# Start binfmt QEMU arm service
sudo systemctl start systemd-binfmt.service

PACSTRAP="sudo pacstrap -MKC pacman.conf /mnt"
CHROOT="sudo arch-chroot /mnt"

# Basic setup

$PACSTRAP base archlinuxarm-keyring 

# Disable initramfs

STOP_INITRAMFS="raspberrypi-stop-initramfs-4-1-aarch64.pkg.tar.xz"
sudo cp -f "$STOP_INITRAMFS" /mnt/root
$CHROOT pacman -U /root/$STOP_INITRAMFS --noconfirm

# Install essential packages

PKGS="linux-rpi raspberrypi-bootloader sudo dhcpcd openssh nss-mdns neofetch htop vim"
$PACSTRAP $PKGS

# Enable services

$CHROOT systemctl enable dhcpcd.service
$CHROOT systemctl enable sshd.service
$CHROOT systemctl enable avahi-daemon.service
$CHROOT systemctl enable systemd-timesyncd.service

# Copy MDNS config

sudo cp -f /etc/nsswitch.conf /mnt/etc/nsswitch.conf

# Bootloader config

sudo cp -f cmdline.txt /mnt/boot
sudo cp -f config.txt /mnt/boot


# Dotfiles

sudo cp -f .vimrc /mnt/etc/skel
sudo cp -f .bashrc /mnt/etc/skel
sudo cp -f .bash_aliases /mnt/etc/skel


# MORE
# Copy ssh public key
