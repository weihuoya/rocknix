# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libXdmcp"
PKG_VERSION="1.1.5"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxdmcp/-/archive/libXdmcp-1.1.5/libxdmcp-libXdmcp-1.1.5.tar.bz2"
PKG_SHA256="1a93be8b497c3166343e5d873373ef523fa85fc96d7d5db22c454cc0a7e7e976"
PKG_TOOLCHAIN="autotools"
PKG_DEPENDS_TARGET="toolchain util-macros libX11"
PKG_LONGDESC="X Display Manager Control Protocol library."

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull --without-xmlto"

post_configure_target() {
  libtool_remove_rpath libtool
}
