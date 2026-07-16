# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXxf86vm"
PKG_VERSION="1.1.6"
PKG_SHA256="31a5841717d7cc70a231388f2773c44c2e402880eef06e71b9046575724c5879"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxxf86vm/-/archive/libXxf86vm-1.1.6/libxxf86vm-libXxf86vm-1.1.6.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11 libXext"
PKG_LONGDESC="The libxxf86vm provides an interface to the server extension XFree86-VidModeExtension."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared --enable-malloc0returnsnull"
