# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXScrnSaver"
PKG_VERSION="1.2.4"
PKG_SHA256="0b8a054ba576a6fb8d000d8983699c001114ad2028840721dda0b0d66c06bece"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="GPL"
PKG_SITE="https://xorg.freedesktop.org/"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxscrnsaver/-/archive/libXScrnSaver-1.2.4/libxscrnsaver-libXScrnSaver-1.2.4.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libXext scrnsaverproto"
PKG_LONGDESC="X11 Screen Saver extension client library."
PKG_BUILD_FLAGS="-sysroot"

PKG_CONFIGURE_OPTS_TARGET="--disable-static \
                           --enable-shared \
                           --enable-malloc0returnsnull"
