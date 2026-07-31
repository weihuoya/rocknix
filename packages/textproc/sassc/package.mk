# SPDX-License-Identifier: MIT
# Copyright (C) 2025-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="sassc"
PKG_VERSION="3.6.2"
PKG_SHA256="608dc9002b45a91d11ed59e352469ecc05e4f58fc1259fc9a9f5b8f0f8348a03"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/sass/sassc"
PKG_URL="https://github.com/sass/sassc/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="toolchain:host libsass:host"
PKG_LONGDESC="A wrapper around libsass used to compile Sass CSS."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_HOST="--disable-shared \
                         --enable-static \
                         --with-pic"
