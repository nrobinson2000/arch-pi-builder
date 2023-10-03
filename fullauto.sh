#!/bin/bash

# todo stop hardcoding this
[ -f arch-arm.img ] && rm -f arch-arm.img
[ -f arch-key ] && rm -f arch-key*

# Create container
bin/img-create

# Partition container
sudo fdisk arch-arm.img << EOF
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

sha256sum arch-arm.img
