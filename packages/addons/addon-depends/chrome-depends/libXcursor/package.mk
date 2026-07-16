# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXcursor"
PKG_VERSION="1.2.3"
PKG_SHA256="93a752ebc5ebcd1901f7839eed264bb175b43ceb28aefd4bf26ff032f8efbdbe"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxcursor/-/archive/libXcursor-1.2.3/libxcursor-libXcursor-1.2.3.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libX11 libXfixes libXrender"
PKG_LONGDESC="X11 Cursor management library.s"
PKG_BUILD_FLAGS="+pic -sysroot"

post_configure_target() {
  libtool_remove_rpath libtool
}
