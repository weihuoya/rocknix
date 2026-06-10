# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libXft"
PKG_VERSION="2.3.8"
PKG_SHA256="d4b7fc83aa3b286f54cf515783db1b7fe413dd9ef696698d174798ea067e42dd"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxft/-/archive/libXft-2.3.8/libxft-libXft-2.3.8.tar.bz2"
PKG_DEPENDS_TARGET="toolchain fontconfig freetype libXrender util-macros xorgproto"
PKG_LONGDESC="X FreeType library."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--disable-static \
                           --enable-shared"
