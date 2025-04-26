# Linux Kernel Debugging Environment

A complete setup for building, running, and debugging the Linux kernel with QEMU and GDB.

## Features

- Automated kernel download and compilation
- Minimal Debian root filesystem creation
- QEMU virtual machine with debugging support
- GDB integration with pre-configured breakpoints
- Easy-to-use scripts for the entire workflow

## Prerequisites

- Linux system (Debian/Ubuntu recommended)
- 10GB+ free disk space
- Internet connection

## Quick Start

```bash
git clone https://github.com/osmten/qemu-kernel-dbg.git
cd qemu-kernel-dbg
./scripts/setup.sh
./scripts/run_kernel_debug.sh
