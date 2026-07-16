# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libmpeg2"
PKG_VERSION="0.5.1-11"
PKG_SHA256="4767e5e8f9795cb7a6aef28f9bcbd1f9affb8ac4a575bf498e63526a3b13314a"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/cisco-open-source/libmpeg2"
PKG_URL="https://github.com/cisco-open-source/libmpeg2/archive/refs/tags/vendor/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="toolchain:host"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The MPEG Library is a collection of C routines to decode MPEG-1 and MPEG-2 movies."

PKG_CONFIGURE_OPTS_TARGET="--disable-sdl \
                           --without-x"

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin
}
