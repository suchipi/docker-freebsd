#!/bin/sh
set -euo pipefail

ARCH=$(uname -m)
case "$ARCH" in
  arm64) ARCH=aarch64 ;;
  amd64) ARCH=x86_64 ;;
esac

docker build --build-arg FREEBSD_ARCH="$ARCH" -t freebsd-cross cross/
docker build --build-arg FREEBSD_ARCH="$ARCH" -t freebsd-qemu qemu/
