# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXtst"
PKG_VERSION="1.2.5"
PKG_SHA256="ea1629bcfaf52b0e60c0fe67a4fc2a63e4ebb8b6156ff996f219bf60865e0a83"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxtst/-/archive/libXtst-1.2.5/libxtst-libXtst-1.2.5.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libXext libXi libX11"
PKG_LONGDESC="The Xtst Library"

PKG_CONFIGURE_OPTS_TARGET="--with-gnu-ld --without-xmlto"

post_configure_target() {
  libtool_remove_rpath libtool
}
