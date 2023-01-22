# arch-pi-builder

Create bootable [Arch Linux ARM](https://archlinuxarm.org/) installations for Raspberry Pi (64-bit)

Adapted from:
https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4



Install QEMU

```bash
yay -S qemu-user-static-binfmt
```

Start `systemd-binfmt.service`

```bash
sudo systemctl start systemd-binfmt.service
```
