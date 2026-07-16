# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libXaw"
PKG_VERSION="1.0.14"
PKG_LICENSE="MIT"
PKG_SITE="http://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxaw/-/archive/libXaw-1.0.14/libxaw-libXaw-1.0.14.tar.bz2"
PKG_SHA256="4128edae303d8427d633f3b69497084ef9ff259c8f73544a3e24fb7fca5cc893"
PKG_TOOLCHAIN="autotools"
PKG_DEPENDS_TARGET="toolchain xorgproto libXt libXmu libX11 libXpm"
PKG_LONGDESC="Athena libary"
PKG_BUILD_FLAGS="+pic"

pre_configure_target() {
  PKG_CONFIGURE_OPTS_TARGET="--disable-static --enable-shared --enable-xthreads"
}
