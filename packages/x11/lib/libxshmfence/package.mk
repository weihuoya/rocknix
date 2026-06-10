# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libxshmfence"
PKG_VERSION="1.3.3"
PKG_SHA256="9d0c889a257eb32012f175675fac146bdf5f29595a08511f9c00e964fb9c6407"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxshmfence/-/archive/libxshmfence-1.3.3/libxshmfence-libxshmfence-1.3.3.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros xorgproto"
PKG_LONGDESC="libxshmfence is the Shared memory 'SyncFence' synchronization primitive."
PKG_TOOLCHAIN="autotools"
PKG_BUILD_FLAGS="+pic"
