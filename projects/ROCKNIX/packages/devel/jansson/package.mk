# SPDX-License-Identifier: MIT
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="jansson"
PKG_VERSION="2.15.1"
PKG_SHA256="0c7114dc0b2d22a670724a1f95922029d7077c19dbf79a584cb8084d2f267f2f"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/akheron/jansson"
PKG_URL="https://github.com/akheron/jansson/releases/download/v${PKG_VERSION}/${PKG_NAME}-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A C library for encoding, decoding and manipulating JSON data."

PKG_TOOLCHAIN="configure"

PKG_CONFIGURE_OPTS_TARGET="--enable-shared \
                           --disable-static \
                           --disable-fast-install"

PKG_CONFIGURE_OPTS_HOST="--enable-static \
                         --disable-shared"

post_makeinstall_target() {
  rm -rf ${INSTALL}/usr/bin
}
