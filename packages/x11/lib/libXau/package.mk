# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXau"
PKG_VERSION="1.0.12"
PKG_SHA256="67d725a29e17ecc2feeaa79acc96bde85e3f54885678952eebecc32b171e6436"
PKG_TOOLCHAIN="meson"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxau/-/archive/libXau-1.0.12/libxau-libXau-1.0.12.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros xorgproto"
PKG_LONGDESC="X authorization file management library"
PKG_BUILD_FLAGS="+pic"

PKG_MESON_OPTS_TARGET="-Ddefault_library=static \
                       -Dprefer_static=true \
                       -Dxthreads=true"
