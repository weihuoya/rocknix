# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xf86-input-synaptics"
PKG_VERSION="1.10.0"
PKG_SHA256="8e1e9ad8d9c1a62ba7c69c0bd312404d48d172cca84ddd55213d8536853abf27"
PKG_LICENSE="GPL"
PKG_SITE="https://lists.freedesktop.org/mailman/listinfo/xorg"
PKG_URL="https://gitlab.freedesktop.org/xorg/driver/xf86-input-synaptics/-/archive/xf86-input-synaptics-1.10.0/xf86-input-synaptics-xf86-input-synaptics-1.10.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain xorg-server libXi libXext libevdev"
PKG_LONGDESC="Synaptics touchpad driver for X.Org."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-xorg-module-dir=${XORG_PATH_MODULES}"

post_configure_target() {
  libtool_remove_rpath libtool
}
