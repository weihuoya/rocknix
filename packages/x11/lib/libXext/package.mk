# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXext"
PKG_VERSION="1.3.6"
PKG_SHA256="97cddd85b3af7d9243cd0f938599bdb8419999e24f6452876c5c34ff0c309daf"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxext/-/archive/libXext-1.3.6/libxext-libXext-1.3.6.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11"
PKG_LONGDESC="LibXext provides an X Window System client interface to several extensions to the X protocol."

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull --without-xmlto"

post_configure_target() {
  libtool_remove_rpath libtool
}
