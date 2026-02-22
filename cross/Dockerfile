FROM debian:trixie-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      clang \
      lld \
      make \
      cmake \
      curl \
      ca-certificates \
      xz-utils \
    && rm -rf /var/lib/apt/lists/*

ARG FREEBSD_RELEASE=15.0
ARG FREEBSD_ARCH=x86_64
ENV FREEBSD_RELEASE=${FREEBSD_RELEASE}
ENV FREEBSD_ARCH=${FREEBSD_ARCH}

# Download FreeBSD base system and extract headers + libraries for sysroot
ENV FREEBSD_SYSROOT=/freebsd-sysroot
RUN case "${FREEBSD_ARCH}" in \
      x86_64)      DIR="amd64/amd64" ;; \
      i386)        DIR="i386/i386" ;; \
      aarch64)     DIR="arm64/aarch64" ;; \
      armv6)       DIR="arm/armv6" ;; \
      armv7)       DIR="arm/armv7" ;; \
      powerpc)     DIR="powerpc/powerpc" ;; \
      powerpc64)   DIR="powerpc/powerpc64" ;; \
      powerpc64le) DIR="powerpc/powerpc64le" ;; \
      riscv64)     DIR="riscv/riscv64" ;; \
      *) echo "Unsupported architecture: ${FREEBSD_ARCH}" >&2; exit 1 ;; \
    esac && \
    mkdir -p ${FREEBSD_SYSROOT} && \
    ( curl -fSL "https://download.freebsd.org/releases/${DIR}/${FREEBSD_RELEASE}-RELEASE/base.txz" \
        -o /tmp/base.txz || \
      curl -fSL "https://archive.freebsd.org/old-releases/${DIR}/${FREEBSD_RELEASE}-RELEASE/base.txz" \
        -o /tmp/base.txz ) && \
    tar -xJf /tmp/base.txz -C ${FREEBSD_SYSROOT} \
      ./usr/include \
      ./usr/lib \
      ./lib && \
    rm /tmp/base.txz

# Add cross-compiler wrapper scripts
COPY freebsd-cc freebsd-c++ /usr/local/bin/

ENV CC=freebsd-cc
ENV CXX=freebsd-c++
ENV LD=ld.lld
