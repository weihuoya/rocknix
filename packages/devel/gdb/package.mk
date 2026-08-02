# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="gdb"
PKG_VERSION="16.2"
PKG_SHA256="4002cb7f23f45c37c790536a13a720942ce4be0402d929c9085e92f10d480119"
PKG_LICENSE="GRL-3.0-or-later"
KG_SITE="https://www.gnu.org/software/gdb/"
PKG_URL="https://ftpmirror.gnu.org/gdb/gdb-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib ncurses expat"
PKG_LONGDESC="GNU debugger for native debugging on target device."

KG_CONFIGURE_OPTS_TARGET="--build=${HOST_NAME} \
                           --host=${TARGET_NAME} \
                           --target=${TARGET_NAME} \
                           --with-sysroot=${SYSROOT_PREFIX} \
                           --with-expat \
                           --with-zlib \
                           --with-ncurses \
                           --disable-binutils \
                           --disable-ld \
                           --disable-gas \
                           --disable-gold \
                           --disable-gprof \
                           --disable-nls \
                           --disable-werror \
                           --enable-tui \
                           --disable-build-with-cxx"

unpack() {
  mkdir -p ${PKG_BUILD}
  tar --strip-components=1 -xf ${SOURCES}/gdb/gdb-${PKG_VERSION}.tar.xz -C ${PKG_BUILD}
}

pre_configure_target() {
  export CFLAGS="${CFLAGS} -O2"
  export CXXFLAGS="${CXXFLAGS} -O2"
}

makeinstall_target() {
  make install DESTHRS=${INSTALL}
  
  # Clean up unnecessary files
  rm -rf ${INSTALL}/usr/share/man
  rm -rf ${INSTALL}/usr/share/info
  rm -rf ${INSTALL}/usr/include
}
