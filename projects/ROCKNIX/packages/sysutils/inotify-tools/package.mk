# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2024-present Team ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="inotify-tools"
PKG_VERSION="4.26.275"
PKG_SHA256="11bba75bafb28d872ee91d0c36b0f8a015fcbc3ce0f8d3275445c95d26e04b81"
PKG_LICENSE="GPL-2.0-only"
PKG_SITE="https://github.com/inotify-tools/inotify-tools"
PKG_URL="https://github.com/inotify-tools/inotify-tools/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A C library and a set of command-line programs for Linux providing a simple interface to inotify."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="-sysroot -cfg-libs"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --disable-doxygen"

post_configure_target() {
  libtool_remove_rpath libtool
}
