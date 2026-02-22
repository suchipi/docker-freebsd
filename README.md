# docker-freebsd-cross

Docker images for:

- Cross-compiling C/C++ to FreeBSD
- Running FreeBSD in a QEMU VM

## Images

### `freebsd-cross` (cross/)

A Debian-based image with clang/lld configured to cross-compile for FreeBSD. It downloads the FreeBSD base system and extracts headers and libraries into a sysroot.

The compiler is available as `freebsd-cc` (C) and `freebsd-c++` (C++), which are also set as `$CC` and `$CXX`.

**Supported architectures:** x86_64, i386, aarch64, armv6, armv7, powerpc, powerpc64, powerpc64le, riscv64

### `freebsd-qemu` (qemu/)

A Debian-based image that boots a FreeBSD VM inside QEMU. A `/workdir` directory is shared between the Docker container and the FreeBSD guest via QEMU's built-in SMB server.

**Supported architectures:** x86_64, i386, aarch64, riscv64 (only architectures for which FreeBSD publishes VM images)

## Build Args

Both images accept the same build args:

| Arg               | Default  | Description             |
| ----------------- | -------- | ----------------------- |
| `FREEBSD_RELEASE` | `15.0`   | FreeBSD release version |
| `FREEBSD_ARCH`    | `x86_64` | Target architecture     |

## Quick Start

Build both images for your host architecture:

```sh
./build-images.sh
```

Cross-compile a program:

```sh
docker run --rm -v "$PWD":/workdir freebsd-cross freebsd-cc -o hello hello.c
```

Test it in a FreeBSD VM:

```sh
# Run a command non-interactively (exit code is propagated)
docker run --rm -v "$PWD":/workdir freebsd-qemu /workdir/hello

# Drop into an interactive FreeBSD shell
docker run --rm -it -v "$PWD":/workdir freebsd-qemu
```

Inside the VM, `/workdir` is mounted read-write and mirrors the host volume.

If you're on a Linux host, you can forward /dev/kvm to the container to get hardware-acceleration:

```sh
docker run --rm -it -v "$PWD":/workdir --privileged -v /dev/kvm:/dev/kvm freebsd-qemu
```
