#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="$(dirname "$SCRIPT_DIR")"

BZIMAGE=$(cat "$WORKDIR/bzImage_path")
DISK_IMAGE=$(cat "$WORKDIR/disk_path")

qemu-system-x86_64 \
  -m 2G \
  -smp 2 \
  -kernel "$BZIMAGE" \
  -append "nokaslr root=/dev/vda console=ttyS0 rw init=/bin/bash" \
  -drive "file=$DISK_IMAGE,format=qcow2,if=virtio" \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device virtio-net-pci,netdev=net0 \
  -nographic \
  -serial mon:stdio \
  -s -S

