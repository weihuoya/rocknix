# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libXmu"
PKG_VERSION="1.1.3"
PKG_SHA256="4a0d4fdb0550b382c0af3d7bb38b324df99adbe6a17ce8f6dcf37d6001d6a119"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxmu/-/archive/libXmu-1.1.3/libxmu-libXmu-1.1.3.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libXext libX11 libXt"
PKG_LONGDESC="LibXmu provides a set of miscellaneous utility convenience functions for X libraries to use."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-static --enable-shared --with-gnu-ld --without-xmlto"
