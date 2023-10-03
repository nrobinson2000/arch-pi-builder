#!/bin/bash

# todo stop hardcoding this
[ -f arch-arm.img ] && rm -f arch-arm.img

bin/img-create

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

bin/loopadd

bin/img-mkfs

bin/img-mount

time ./install.sh

sudo arch-chroot /mnt
