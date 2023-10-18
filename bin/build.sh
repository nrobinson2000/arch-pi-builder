#!/bin/bash

# Load build settings
source build/conf.sh

# Delete artifacts
[ -f "build/$IMG_NAME" ] && rm -f "build/$IMG_NAME"*
[ -f "build/$KEY_NAME" ] && rm -f "build/$KEY_NAME" "build/${KEY_NAME}.pub"

# Create container
bin/img-create

# Partition container
bin/img-part

# Mount container
bin/loopadd
bin/img-mkfs
bin/img-mount

# Pacstrap and config system
time bin/install.sh
