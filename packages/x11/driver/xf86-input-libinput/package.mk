# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xf86-input-libinput"
PKG_VERSION="1.5.0"
PKG_SHA256="c56db5187a75779a6d7c0429590587d2f82d479d19d4af3ac278d41b84ff6b87"
PKG_LICENSE="MIT"
PKG_SITE="https://www.freedesktop.org/wiki/Software/libinput/"
PKG_URL="https://gitlab.freedesktop.org/xorg/driver/xf86-input-libinput/-/archive/xf86-input-libinput-1.5.0/xf86-input-libinput-xf86-input-libinput-1.5.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libinput xorg-server"
PKG_LONGDESC="This is an X driver based on libinput."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--with-xorg-module-dir=${XORG_PATH_MODULES}"

post_makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/X11/xorg.conf.d
    cp ${PKG_BUILD}/conf/*-libinput.conf ${INSTALL}/usr/share/X11/xorg.conf.d
}
