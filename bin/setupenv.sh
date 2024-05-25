#!/bin/bash

# Prepare host system for building
sudo pacman -S base-devel arch-install-scripts qemu-user-static-binfmt dosfstools parted

sudo pacman -U pkgs/archlinuxarm-keyring-20240419-1-any.pkg.tar.xz
