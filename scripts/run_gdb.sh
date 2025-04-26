#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="$(dirname "$SCRIPT_DIR")"

VMLINUX=$(cat "$WORKDIR/vmlinux_path")

gdb -q \
  -ex "file $VMLINUX" \
  -ex "target remote :1234" \
  -ex "break start_kernel" \
  -ex "continue"

