#!/bin/bash

# Prepare host system for building
sudo pacman -S arch-install-scripts qemu-user-static-binfmt dosfstools
sudo pacman -U pkgs/archlinuxarm-keyring-20140119-2-any.pkg.tar.xz
