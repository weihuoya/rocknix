# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXrender"
PKG_VERSION="0.9.12"
PKG_SHA256="a4540eb38f91a895288c304d2e7156d8bf2bf64f61ce7cdd8260d3bd290784e2"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxrender/-/archive/libXrender-0.9.12/libxrender-libXrender-0.9.12.tar.bz2"
PKG_TOOLCHAIN="autotools"
PKG_DEPENDS_TARGET="toolchain util-macros libX11"
PKG_LONGDESC="The X Rendering Extension introduces digital image composition within the X Window System."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull"

post_configure_target() {
  libtool_remove_rpath libtool
}
