# arch-pi-builder

Create bootable Arch Linux ARM installations for Raspberry Pi (64-bit)

# Install dependencies 

sudo pacman -S arch-install-scripts qemu-user-static-binfmt
sudo pacman -U archlinuxarm-keyring-20140119-2-any.pkg.tar.xz

# Create partitions and filesystems

Use fdisk
Partition 1: vfat (+200M)
Partition 2: ext4 (rest of disk)

sudo mkfs.vfat /dev/sdX1
sudo mkfs.ext4 /dev/sdX2

# Mount filesystems

sudo mount /dev/sdX2 /mnt
sudo mkdir /mnt/boot
sudo mount /dev/sdX1 /mnt/boot

# Install system

./install.sh

# Post install setup

sudo arch-chroot /mnt
passwd
useradd -mG wheel USERNAME
passwd USERNAME

vim /etc/hostname
vim -p /etc/locale.gen /etc/locale.conf
locale-gen
