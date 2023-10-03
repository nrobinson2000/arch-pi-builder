#!/bin/bash

# Prepare host system for building
sudo pacman -S arch-install-scripts qemu-user-static-binfmt
sudo pacman -U pkgs/archlinuxarm-keyring-20140119-2-any.pkg.tar.xz

# Downgrade packages to 8.1.0-2
yay -S downgrade || exit
sudo downgrade qemu-user-static qemu-user-static-binfmt
