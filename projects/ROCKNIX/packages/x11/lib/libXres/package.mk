# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libXres"
PKG_VERSION="1.2.2"
PKG_SHA256="4199d98ba7947e9fb7abc1714455ec15551c75ef40a3e4cb501e1b4f345f8e30"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="MIT"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxres/-/archive/libXres-1.2.2/libxres-libXres-1.2.2.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11 libXext"
PKG_LONGDESC="X11 library for the X Resource Extension (client resource ID listing)."
PKG_BUILD_FLAGS="+pic"

# Cross-compile: do not run the malloc(0) runtime probe (same as other libX* packages).
PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull"

post_configure_target() {
  libtool_remove_rpath libtool
}
