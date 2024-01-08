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

The image and root SSH key will be created in `build/`

## Inspect the image (optional)

```
$ sudo arch-chroot /mnt
```

## Detach the image

```
$ bin/teardown.sh
```

Check with `lsblk` that the mounts and loop device are deactivated.

## Deploy the image

Edit `bin/write-usb.sh` and set `DEVICE` to the USB block device you want to write to.

Run the script to write the image and expand the root partition:

```
$ bin/write-usb.sh
```

## Boot the install

Insert the USB into the Raspberry Pi and connect ethernet and power.

The Pi will connect using DHCP and be available via mDNS. (.local)

## Connect

The SSH server will be running and you may connect using the ssh key generated during the build.

```
$ ssh -i build/arch-key root@arch-arm.local
```

## Create a non-root user

Create a user in the wheel group. This makes them a sudoer.

```
$ useradd -mG wheel <USER>
$ passwd <USER>
```

The dotfiles in /etc/skel will be copied into the user's home directory.

## Use the Pi

There are many things to do with a Raspberry Pi running Arch Linux ARM. I hope you have fun.

## Bonus

You can compress the image for distribution with the following:

```
$ sudo xz build/arch-arm.img --keep --verbose -T 0
```
