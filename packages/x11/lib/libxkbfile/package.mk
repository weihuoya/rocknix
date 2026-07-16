# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libxkbfile"
PKG_VERSION="1.1.3"
PKG_SHA256="50c9c31a94fcfb5dbfb6c27831ef8c2f9313eb47d5079737265c589fe3eaf049"
PKG_TOOLCHAIN="meson"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxkbfile/-/archive/libxkbfile-1.1.3/libxkbfile-libxkbfile-1.1.3.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11"
PKG_LONGDESC="Libxkbfile provides an interface to read and manipulate description files for XKB, the X11 keyboard configuration extension."

PKG_MESON_OPTS_TARGET="-Ddefault_library=static"
