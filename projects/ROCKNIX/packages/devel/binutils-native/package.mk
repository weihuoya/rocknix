# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="binutils-native"
PKG_VERSION="2.47"
PKG_SHA256="154ab23b60070e8f27013c22977f1129425d67d1e8acd6e13010e617811e4cff"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://www.gnu.org/software/binutils/"
PKG_URL="https://ftp.gnu.org/gnu/binutils/binutils-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib"
PKG_LONGDESC="GNU binutils for native compilation on target device."

PKG_CONFIGURE_OPTS_TARGET="--with-sysroot=${SYSROOT_PREFIX} \
                           --with-system-zlib \
                           --enable-ld=default \
                           --disable-gold \
                           --enable-plugins \
                           --enable-64-bit-bfd \
                           --disable-werror \
                           --disable-multilib \
                           --disable-nls"

pre_configure_target() {
  unset CPP
  unset CPPFLAGS
}

make_target() {
  make configure-host
  make MAKEINFO=true -j${CONCURRENCY_MAKE_LEVEL}
}

makeinstall_target() {
  make DESTDIR=${INSTALL} MAKEINFO=true install
  rm -rf ${INSTALL}/usr/share/info
  rm -rf ${INSTALL}/usr/share/man
}
