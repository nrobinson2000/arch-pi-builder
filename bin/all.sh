#!/bin/bash

# Load build settings
source build/conf.sh

# Do everything
bin/build.sh
bin/teardown.sh
sync
sleep 1

# Compress image
sudo xz "build/$IMG_NAME" --keep --verbose -T 0
sha256sum "build/$IMG_NAME.xz"
