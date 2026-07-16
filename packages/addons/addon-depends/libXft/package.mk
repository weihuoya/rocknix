# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXft"
PKG_VERSION="2.3.9"
PKG_SHA256="5bfc4853e99a9e22461be51315fb6809064251cf0b1a95bf195cfe89bb722356"
PKG_TOOLCHAIN="meson"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxft/-/archive/libXft-2.3.9/libxft-libXft-2.3.9.tar.bz2"
PKG_DEPENDS_TARGET="toolchain fontconfig freetype libXrender util-macros xorgproto"
PKG_LONGDESC="X FreeType library."
PKG_BUILD_FLAGS="+pic -sysroot"

PKG_MESON_OPTS_TARGET="-Ddefault_library=static"
