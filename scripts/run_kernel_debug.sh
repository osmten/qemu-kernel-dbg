#!/bin/bash
set -e

# Configurable paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="$(dirname "$SCRIPT_DIR")" 
KERNEL_REPO="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
KERNEL_DIR="$WORKDIR/linux"
DISK_IMAGE="$WORKDIR/rootfs.qcow2"

# Create working dir
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Clone or update kernel
if [ ! -d "$KERNEL_DIR" ]; then
    git clone --depth 1 "$KERNEL_REPO" "$KERNEL_DIR"
    cd "$KERNEL_DIR"
    make defconfig

    # Embed debug info
    ./scripts/config --enable DEBUG_INFO_DWARF5
    make olddefconfig
    
else
    cd "$KERNEL_DIR"
    git pull
fi

# Build kernel if needed
if [ ! -f "vmlinux" ] || [ ! -f "arch/x86/boot/bzImage" ]; then
    echo "Compiling kernel..."
    make -j$(nproc)
fi

# Create minimal rootfs if needed
if [ ! -f "$DISK_IMAGE" ]; then
    echo "Creating minimal rootfs..."
    TEMP_IMG="$WORKDIR/rootfs.ext4"
    dd if=/dev/zero of="$TEMP_IMG" bs=1M count=512
    mkfs.ext4 "$TEMP_IMG"
    
    mkdir -p "$WORKDIR/rootmnt"
    sudo mount "$TEMP_IMG" "$WORKDIR/rootmnt"
    sudo debootstrap --arch=amd64 stable "$WORKDIR/rootmnt" http://deb.debian.org/debian
    echo "root:root" | sudo chroot "$WORKDIR/rootmnt" chpasswd
    sudo umount "$WORKDIR/rootmnt"
    qemu-img convert -f raw -O qcow2 "$TEMP_IMG" "$DISK_IMAGE"
    rm "$TEMP_IMG"
fi

# Export paths
echo "$KERNEL_DIR/vmlinux" > "$WORKDIR/vmlinux_path"
echo "$KERNEL_DIR/arch/x86/boot/bzImage" > "$WORKDIR/bzImage_path"
echo "$DISK_IMAGE" > "$WORKDIR/disk_path"

# Launch QEMU and GDB
gnome-terminal -- bash -c "$SCRIPT_DIR/run_qemu.sh; exec bash"
sleep 2
gnome-terminal -- bash -c "$SCRIPT_DIR/run_gdb.sh; exec bash"
