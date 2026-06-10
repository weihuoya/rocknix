# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="font-util"
PKG_VERSION="1.4.1"
PKG_SHA256="126ab9e5ee5cb3be2db2590cef1cb91cecde0e89d897d4199c8ba8f1319540dc"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/font/util/-/archive/font-util-1.4.1/util-font-util-1.4.1.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros"
PKG_DEPENDS_HOST="util-macros"
PKG_LONGDESC="X.org font utilities."

PKG_CONFIGURE_OPTS_TARGET="--with-fontrootdir=/usr/share/fonts \
                           --with-mapdir=/usr/share/fonts/util"

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin
}
