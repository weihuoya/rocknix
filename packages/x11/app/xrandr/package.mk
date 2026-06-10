# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xrandr"
PKG_VERSION="1.5.3"
PKG_SHA256="67ee81666ae97103acf289ac4b609476c3f0c20f65377edf5b35d18a0bda2483"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/app/xrandr/-/archive/xrandr-1.5.3/xrandr-xrandr-1.5.3.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libXrandr"
PKG_LONGDESC="Xrandr is a primitive command line interface to the RandR extension and used to set the screen size, orientation and/or reflection."

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin/xkeystone
}
