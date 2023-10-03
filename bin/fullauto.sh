#!/bin/bash

# Load build settings
source build/conf.sh

# Delete artifacts
[ -f "build/$IMG_NAME" ] && rm -f "build/$IMG_NAME"
[ -f "build/$KEY_NAME" ] && rm -f "build/$KEY_NAME" "build/${KEY_NAME}.pub"

# Create container
bin/img-create

# Partition container
sudo fdisk "build/$IMG_NAME" << EOF
o
n
p
1

+200M
t
0c
n
p
2


p
w
EOF

# Mount container
bin/loopadd
bin/img-mkfs
bin/img-mount

# Pacstrap and config system
time ./install.sh

# sudo arch-chroot /mnt

sha256sum "build/$IMG_NAME"
