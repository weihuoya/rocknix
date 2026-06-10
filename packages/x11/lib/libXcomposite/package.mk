# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXcomposite"
PKG_VERSION="0.4.6"
PKG_SHA256="2838e76e500479321f498f51c2463966495b434fc68ac47660d80f85d9597191"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxcomposite/-/archive/libXcomposite-0.4.6/libxcomposite-libXcomposite-0.4.6.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libXfixes libXext libX11"
PKG_LONGDESC="X Composite Library"
PKG_BUILD_FLAGS="+pic"

post_configure_target() {
  libtool_remove_rpath libtool
}
