# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xtrans"
PKG_VERSION="1.6.0"
PKG_SHA256="5586d6dee7ab1d111bd8c4c07c66e25769a6dbe7e7d45de9a7298dfff2576a35"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxtrans/-/archive/xtrans-1.6.0/libxtrans-xtrans-1.6.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros"
PKG_LONGDESC="Abstract network code for X."
PKG_BUILD_FLAGS="-cfg-libs"

PKG_CONFIGURE_OPTS_TARGET="--without-xmlto"

post_makeinstall_target() {
  mkdir -p ${SYSROOT_PREFIX}/usr/lib/pkgconfig
    cp xtrans.pc ${SYSROOT_PREFIX}/usr/lib/pkgconfig
}
