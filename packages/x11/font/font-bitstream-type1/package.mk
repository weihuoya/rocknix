# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="font-bitstream-type1"
PKG_VERSION="1.0.4"
PKG_SHA256="ed6c7af21d8777718415388eae56326794758c6b74cc7095085d372c7b5f3fc1"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/font/bitstream-type1/-/archive/font-bitstream-type1-1.0.4/bitstream-type1-font-bitstream-type1-1.0.4.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros font-xfree86-type1"
PKG_LONGDESC="Bitstream font family."

PKG_CONFIGURE_OPTS_TARGET="--with-fontrootdir=/usr/share/fonts"

post_install() {
  mkfontdir ${INSTALL}/usr/share/fonts/Type1
  mkfontscale ${INSTALL}/usr/share/fonts/Type1
}
