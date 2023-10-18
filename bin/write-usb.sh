#!/bin/bash

# Load build settings
source build/conf.sh

DEVICE="/dev/sda"

sudo cp "build/$IMG_NAME" "$DEVICE" || exit
sync
sudo parted -s "$DEVICE" resizepart 2 100%
sudo fsck -y "${DEVICE}2" 
sudo resize2fs -f "${DEVICE}2"
