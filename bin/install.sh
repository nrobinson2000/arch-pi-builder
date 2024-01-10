#!/bin/bash

# Pacstrap and setup Arch Linux ARM

# Load build settings
source build/conf.sh

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

# Pre setup
$PACSTRAP pacman

# Fix for archlinuxarm SHA1 signing key
# https://archlinuxarm.org/forum/viewtopic.php?f=15&t=16701&p=71917
echo "allow-weak-key-signatures" | sudo tee -a $MOUNT/etc/pacman.d/gnupg/gpg.conf

# Disable mkinitcpio entirely
PKG="mkinitcpio-dummy/mkinitcpio-dummy-2024.1-1-any.pkg.tar.zst"
sudo pacstrap -MC "$CONF_DIR/pacman.conf" -U "$MOUNT" "$PKGS_DIR/$PKG"

# Basic setup
$PACSTRAP base archlinuxarm-keyring

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
sudo ln -sf /run/systemd/resolve/stub-resolv.conf $MOUNT/etc/resolv.conf

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
echo "en_US.UTF-8 UTF-8" | sudo tee $MOUNT/etc/locale.gen
echo "LANG=en_US.UTF-8" | sudo tee $MOUNT/etc/locale.conf
$CHROOT locale-gen

# SSH Keypair
ssh-keygen -t ed25519 -f "build/$KEY_NAME" -N ''
sudo mkdir -p $MOUNT/root/.ssh
sudo cp "build/${KEY_NAME}.pub" $MOUNT/root/.ssh/authorized_keys

# Hostname
sudo cp $CONF_DIR/hostname $MOUNT/etc/hostname

# Clear pacman cache
$CHROOT rm -rf /var/cache/pacman/pkg
