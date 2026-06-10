# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libICE"
PKG_VERSION="1.1.2"
PKG_SHA256="f51084de058daa6d4eb74cb2754ac86a154fe886ae24e67822cf73bca3d41dd8"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libice/-/archive/libICE-1.1.2/libice-libICE-1.1.2.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros xtrans"
PKG_LONGDESC="X Inter-Client Exchange (ICE) protocol library."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --disable-ipv6 \
                           --without-xmlto"
