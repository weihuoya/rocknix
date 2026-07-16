# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="font-xfree86-type1"
PKG_VERSION="1.0.5"
PKG_SHA256="5c5e90d2c48fe451b646072b4bb2e3def704d3beb1ae8b2f117a54359c73786a"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/font/xfree86-type1/-/archive/font-xfree86-type1-1.0.5/xfree86-type1-font-xfree86-type1-1.0.5.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros"
PKG_LONGDESC="A Xfree86 Inc. Type1 font."

PKG_CONFIGURE_OPTS_TARGET="--with-fontrootdir=/usr/share/fonts"

post_install() {
  mkfontdir ${INSTALL}/usr/share/fonts/Type1
  mkfontscale ${INSTALL}/usr/share/fonts/Type1
}
