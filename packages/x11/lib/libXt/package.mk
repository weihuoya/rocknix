# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXt"
PKG_VERSION="1.3.1"
PKG_SHA256="89dca62be7a7981dd92d1bd2ad1986c947db06a383a180244242425c1bec8555"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxt/-/archive/libXt-1.3.1/libxt-libXt-1.3.1.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11 libSM"
PKG_LONGDESC="libXt provides the X Toolkit Intrinsics library, an abstract widget library upon which other toolkits are based."

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --with-gnu-ld \
                           --enable-malloc0returnsnull"

pre_make_target() {
  make -C util CC=${HOST_CC} \
               CFLAGS="${HOST_CFLAGS} " \
               LDFLAGS="${HOST_LDFLAGS}" \
               makestrs
}
