# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXfixes"
PKG_VERSION="6.0.1"
PKG_SHA256="b12276fbb5bdbdfd86beb453c4c1ecd64ea5d7c52d36fc983dad7ac5a2c44300"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxfixes/-/archive/libXfixes-6.0.1/libxfixes-libXfixes-6.0.1.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11"
PKG_LONGDESC="X Fixes Library"
PKG_BUILD_FLAGS="+pic"

post_configure_target() {
  libtool_remove_rpath libtool
}
