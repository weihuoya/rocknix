# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="iproute2"
PKG_VERSION="7.3.0"
PKG_SHA256="5c1789d290bba048a6135ed1ab81b0402dd0fb528d1f1421765c42b1fc3d6289"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="https://wiki.linuxfoundation.org/networking/iproute2"
PKG_URL="https://mirrors.kernel.org/pub/linux/utils/net/iproute2/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Linux kernel networking control utilities, including the full ip command."
PKG_TOOLCHAIN="manual"

configure_target() {
  cd ${PKG_BUILD}
  ./configure --prefix=/usr --libdir=/usr/lib --libbpf_force=off
}

make_target() {
  make -C ${PKG_BUILD} SUBDIRS="lib ip" CC="${CC}" CCOPTS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/sbin
  cp ${PKG_BUILD}/ip/ip ${INSTALL}/usr/sbin/
}
