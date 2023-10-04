# arch-pi-builder

Install Arch Linux ARM for Raspberry Pi (aarch64) using a cross-arch pacstrap

## Setup build environment

```
$ bin/setupenv.sh
```

## Build the image

```
$ bin/build.sh
```

The image and root SSH key will be created in build/

## Inspect the image (optional)

```
$ sudo arch-chroot /mnt
```

## Detach the image

```
$ bin/teardown.sh
```

Check with `lsblk` that the mounts and loop device are deactivated.
The loop device may not be deactivated on the first try, so repeat as needed.

```
$ bin/teardown.sh && lsblk
```

## Deploy the image

Copy the image to a physical boot medium and expand the filesystem.
> Make sure to substitute /dev/sdX for the actual name of the USB block device.

Copy the image to the device:

```
$ sudo cp build/arch-arm.img /dev/sdX
$ sync
```

Delete and recreate the second partition:

```
$ sudo fdisk /dev/sdX
```

Resize the filesystem:

```
$ sudo fsck -y /dev/sdX2
$ sudo resize2fs /dev/sdX2
$ sync
```

# Boot the install

Insert the USB into the Raspberry Pi and connect ethernet and power.

The Pi will connect using DHCP and be available with MDNS.

## Connect

The SSH server will be running and you may connect using the ssh key generated during the build.

```
$ ssh -i build/arch-key root@arch-arm.local
```

## Create a non-root user

Create a user in the wheel group. This makes them a sudoer.

```
$ useradd -mG wheel <USER>
```

The dotfiles in /etc/skel will be copied into the user's home upon creation.

## Use the Pi

There are many things to do with a Raspbery Pi running Arch Linux ARM. I hope you have fun.
