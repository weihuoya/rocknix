# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXdamage"
PKG_VERSION="1.1.6"
PKG_SHA256="5b99ded36f377a50ff1383ba6568cb4722c91a51a482a7f70a75f618113e9255"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxdamage/-/archive/libXdamage-1.1.6/libxdamage-libXdamage-1.1.6.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11 libXfixes"
PKG_LONGDESC="LibXdamage provides an X Window System client interface to the DAMAGE extension to the X protocol."
PKG_BUILD_FLAGS="+pic"

post_configure_target() {
  libtool_remove_rpath libtool
}
