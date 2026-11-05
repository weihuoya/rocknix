# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

. ${ROOT}/packages/sysutils/squashfs-tools/package.mk

PKG_DEPENDS_TARGET="toolchain libarchive lzo lz4 zstd"

make_target() {
  make -C squashfs-tools clean
  make -C squashfs-tools \
          mksquashfs \
          unsquashfs \
          GZIP_SUPPORT=1 \
          XZ_SUPPORT=0 \
          LZO_SUPPORT=1 \
          LZ4_SUPPORT=1 \
          ZSTD_SUPPORT=1 \
          XATTR_SUPPORT=0 \
          XATTR_DEFAULT=0
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/squashfs-tools/mksquashfs ${INSTALL}/usr/bin/mksquashfs
  cp ${PKG_BUILD}/squashfs-tools/unsquashfs ${INSTALL}/usr/bin/unsquashfs
  chmod 755 ${INSTALL}/usr/bin/mksquashfs ${INSTALL}/usr/bin/unsquashfs
}
