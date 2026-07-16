# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libpciaccess"
PKG_VERSION="0.18.1"
PKG_SHA256="6faca7b27ed76547bdd44a152a04b37d9ddc8de7f17e58780e7f80fb2c0971cd"
PKG_TOOLCHAIN="meson"
PKG_LICENSE="OSS"
PKG_SITE="https://freedesktop.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/archive/libpciaccess-0.18.1/libpciaccess-libpciaccess-0.18.1.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros zlib"
PKG_LONGDESC="X.org libpciaccess library."

PKG_MESON_OPTS_TARGET="-Dpci-ids=/usr/share \
                       -Dzlib=enabled"

pre_configure_target() {
  CFLAGS+=" -D_LARGEFILE64_SOURCE"
}
