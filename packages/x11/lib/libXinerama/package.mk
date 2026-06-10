# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXinerama"
PKG_VERSION="1.1.5"
PKG_SHA256="dbf21b4db9534ea37894e873b826f4698564ae40b89d07b8ee3faf160a54df2b"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxinerama/-/archive/libXinerama-1.1.5/libxinerama-libXinerama-1.1.5.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libXext"
PKG_LONGDESC="libXinerama is the Xinerama library."

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --enable-malloc0returnsnull"

post_configure_target() {
  libtool_remove_rpath libtool
}
