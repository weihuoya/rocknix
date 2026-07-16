# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libXcursor"
PKG_VERSION="1.2.1"
PKG_SHA256="1a277e569932f95004bed95ce8b26dcab9a366605aea9fc4b693b00cc051263b"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxcursor/-/archive/libXcursor-1.2.1/libxcursor-libXcursor-1.2.1.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libX11 libXfixes libXrender"
PKG_LONGDESC="X11 Cursor management library.s"
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic -sysroot"

post_configure_target() {
  libtool_remove_rpath libtool
}

post_makeinstall_target() {
  mkdir -p ${SYSROOT_PREFIX}/usr/include/X11/Xcursor
    cp include/X11/Xcursor/Xcursor.h ${SYSROOT_PREFIX}/usr/include/X11/Xcursor

  mkdir -p ${SYSROOT_PREFIX}/usr/lib/pkgconfig
    cp xcursor.pc ${SYSROOT_PREFIX}/usr/lib/pkgconfig
    cp src/.libs/libXcursor.la ${SYSROOT_PREFIX}/usr/lib
    cp src/.libs/libXcursor.so* ${SYSROOT_PREFIX}/usr/lib
}
