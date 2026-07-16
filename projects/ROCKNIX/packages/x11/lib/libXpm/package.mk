# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libXpm"
PKG_VERSION="3.5.13"
PKG_LICENSE="MIT"
PKG_SITE="http://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxpm/-/archive/libXpm-3.5.13/libxpm-libXpm-3.5.13.tar.bz2"
PKG_SHA256="4b63c38c85fed24e790a73f4534a3bd9cdc594077c2bd60b197da68a9aa75b99"
PKG_TOOLCHAIN="autotools"
PKG_DEPENDS_TARGET="toolchain xorgproto libXt libXmu libX11 libXext"
PKG_LONGDESC="XPM pixmap libary"
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-static --enable-shared --enable-xthreads"
