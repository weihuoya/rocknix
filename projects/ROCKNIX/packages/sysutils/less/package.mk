# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="less"
PKG_VERSION="668"
PKG_SHA256="2819f55564d86d542abbecafd82ff61e819a3eec967faa36cd3e68f1596a44b8"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://www.greenwoodsoftware.com/less/"
PKG_URL="http://ftp.gnu.org/gnu/less/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ncurses"
PKG_LONGDESC="less is a full-featured terminal pager with ANSI color passthrough (-R), replacing the BusyBox less applet."

PKG_CONFIGURE_OPTS_TARGET="--with-regex=posix"

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/share
}
