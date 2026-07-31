# SPDX-License-Identifier: MIT
# Copyright (C) 2025-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libsass"
PKG_VERSION="3.6.6"
PKG_SHA256="11f0bb3709a4f20285507419d7618f3877a425c0131ea8df40fe6196129df15d"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/sass/libsass"
PKG_URL="https://github.com/sass/libsass/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="toolchain:host"
PKG_LONGDESC="A C/C++ implementation of a Sass compiler."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--disable-shared \
                         --enable-static \
                         --with-pic"
