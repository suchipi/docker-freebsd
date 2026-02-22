FROM debian:trixie-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      ca-certificates \
      xz-utils \
      expect \
      samba \
    && rm -rf /var/lib/apt/lists/*

ARG FREEBSD_RELEASE=15.0
ARG FREEBSD_ARCH=x86_64
ENV FREEBSD_RELEASE=${FREEBSD_RELEASE}
ENV FREEBSD_ARCH=${FREEBSD_ARCH}

# Install architecture-specific QEMU system emulator
RUN apt-get update && \
    case "${FREEBSD_ARCH}" in \
      x86_64|i386)  apt-get install -y --no-install-recommends qemu-system-x86 ;; \
      aarch64)      apt-get install -y --no-install-recommends qemu-system-arm qemu-efi-aarch64 ;; \
      riscv64)      apt-get install -y --no-install-recommends qemu-system-misc ;; \
      *) echo "FreeBSD does not provide VM images for architecture: ${FREEBSD_ARCH}" >&2; exit 1 ;; \
    esac && \
    rm -rf /var/lib/apt/lists/*

# Download FreeBSD VM image
RUN case "${FREEBSD_ARCH}" in \
      x86_64)  DIR="amd64";   FILE_ARCH="amd64" ;; \
      i386)    DIR="i386";    FILE_ARCH="i386" ;; \
      aarch64) DIR="aarch64"; FILE_ARCH="arm64-aarch64" ;; \
      riscv64) DIR="riscv64"; FILE_ARCH="riscv-riscv64" ;; \
    esac && \
    FILENAME="FreeBSD-${FREEBSD_RELEASE}-RELEASE-${FILE_ARCH}-ufs.qcow2.xz" && \
    ( curl -fSL "https://download.freebsd.org/releases/VM-IMAGES/${FREEBSD_RELEASE}-RELEASE/${DIR}/Latest/${FILENAME}" \
        -o /tmp/freebsd.qcow2.xz || \
      curl -fSL "https://archive.freebsd.org/old-releases/VM-IMAGES/${FREEBSD_RELEASE}-RELEASE/${DIR}/Latest/${FILENAME}" \
        -o /tmp/freebsd.qcow2.xz ) && \
    xz -d /tmp/freebsd.qcow2.xz && \
    mv /tmp/freebsd.qcow2 /freebsd.qcow2

RUN mkdir -p /workdir

RUN mv /usr/sbin/smbd /usr/sbin/smbd.real
COPY smbd-wrapper /usr/sbin/smbd

COPY boot-freebsd boot-freebsd.expect /usr/local/bin/

ENTRYPOINT ["boot-freebsd"]
