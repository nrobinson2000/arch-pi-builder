# arch-pi-builder

Create Arch Linux ARM installation for Raspberry Pi (aarch64) using a cross-arch img pacstrap

# Install dependencies

sudo pacman -S arch-install-scripts qemu-user-static-binfmt
sudo pacman -U archlinuxarm-keyring-20140119-2-any.pkg.tar.xz

There is currently a bug with qemu-static and you need to downgrade to 8.1.0-2:

yay -S downgrade
sudo downgrade qemu-user-static qemu-user-static-binfmt

```
qemu-user-static 8.1.0-2
qemu-user-static-binfmt 8.1.0-2
```

# Create a disk image

$ bin/img-create

# Create partitions

$ sudo fdisk arch-arm.img

Partition 1: vfat (+200M)
Partition 2: ext4 (rest of disk)

# Attach loop device

$ bin/loopadd

# Create filesystems

$ bin/img-mkfs
$ bin/img-mount

# Install system

$ ./install.sh

# Post install setup

sudo arch-chroot /mnt
passwd
useradd -mG wheel USERNAME
passwd USERNAME

vim /etc/hostname
vim -p /etc/locale.gen /etc/locale.conf
locale-gen

# Exit chroot and unmount

$ bin/img-umount
$ bin/loopdel

# Compress image for distribution (optional)

$ sudo xz arch-arm.img --keep --verbose -T 0

# Write disk image to USB

$ sudo dd if=arch-arm.img of=/dev/sdX bs=512M status=progress

# Resize root partition to fill USB

$ sudo fdisk /dev/sdX
$ sudo fsck /dev/sdX2
$ sudo resize2fs /dev/sdX2

# TODO
- Create SSH keypair during setup, copy public key to image
- Define hostname during setup
- Auto locales
