#!/bin/bash
set -e

echo "Setting up Linux Kernel Debugging Environment"
echo "This will install required packages and dependencies"

# Check if we're root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo"
    exit 1
fi

# Update package lists
apt-get update

# Install build dependencies
apt-get install -y \
    git \
    build-essential \
    flex \
    bison \
    libssl-dev \
    libelf-dev \
    bc \
    qemu-system-x86 \
    gdb \
    debootstrap \
    gnome-terminal \
    curl

echo "Setup completed successfully!"
echo "You can now run ./scripts/run_kernel_debug.sh"
