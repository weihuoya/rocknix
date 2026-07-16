# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xkbcomp"
PKG_VERSION="1.4.7"
PKG_SHA256="619682d8254930a6b5e71b50d9547bffedb136932279ae7335370544cf1a5c29"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/app/xkbcomp/-/archive/xkbcomp-1.4.7/xkbcomp-xkbcomp-1.4.7.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11 libxkbfile"
PKG_LONGDESC="The xkbcomp keymap compiler converts a description of an XKB keymap into one of several output formats."

PKG_CONFIGURE_OPTS_TARGET="--with-xkb-config-root=${XORG_PATH_XKB}"
