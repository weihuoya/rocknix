# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libfontenc"
PKG_VERSION="1.1.8"
PKG_SHA256="8c06c8c620fbbb72e45663d63f08a95a95b8c2ec2530280f032e7225d02a0c9d"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libfontenc/-/archive/libfontenc-1.1.8/libfontenc-libfontenc-1.1.8.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros zlib font-util xorgproto"
PKG_LONGDESC="Libfontenc is a library which helps font libraries portably determine and deal with different encodings of fonts."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-static --disable-shared"
