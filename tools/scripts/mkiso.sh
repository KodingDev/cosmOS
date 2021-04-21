#!/usr/bin/env bash
set -e

# Define variables
PROJECT_DIR="$(dirname "${BASH_SOURCE[0]}")/../.."
BUILD_DIR="$PROJECT_DIR/build"
ISO_DIR="$BUILD_DIR/iso"

# Recreate build dir
rm -rf "$ISO_DIR"
mkdir -p "$ISO_DIR/boot/grub"

# Copy kernel files
cp "$PROJECT_DIR/tools/iso/grub.cfg" "$ISO_DIR/boot/grub/grub.cfg"
cp cosmOS "$ISO_DIR/boot/kernel"

# Create the grub rescue
if [ "$(uname)" = "Darwin" ]; then
  docker run -v "$(realpath "$BUILD_DIR")":/build cosmos:build grub-mkrescue -o /build/kernel.iso /build/iso
else
  grub-mkrescue -o kernel.iso "$ISO_DIR"
fi

# Cleanup
rm -rf "$ISO_DIR"