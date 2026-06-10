# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="util-macros"
PKG_VERSION="1.20.2"
PKG_SHA256="e817e356ae6a2b72978a7ffecf7c2ab47aef376827af0a0e1cf2c6fd2f542d62"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/util/macros/-/archive/util-macros-1.20.2/macros-util-macros-1.20.2.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="X.org autoconf utilities such as M4 macros."
PKG_BUILD_FLAGS="-cfg-libs"

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr
}
