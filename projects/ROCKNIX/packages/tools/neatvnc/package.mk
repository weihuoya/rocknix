# SPDX-License-Identifier: ISC
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="neatvnc"
PKG_VERSION="1.0.0"
PKG_SHA256="993dedc30e72981650770c04438e9759537e4677010e2dab5e792c39afe74601"
PKG_LICENSE="ISC"
PKG_SITE="https://github.com/any1/neatvnc"
PKG_URL="https://github.com/any1/neatvnc/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain pixman aml libjpeg-turbo gnutls nettle gmp libdrm libpng zlib"
PKG_LONGDESC="A Neat VNC server library"

PKG_MESON_OPTS_TARGET="-Dexamples=false \
                       -Dbenchmarks=false \
                       -Dtests=false \
                       -Djpeg=enabled \
                       -Dtls=enabled \
                       -Dnettle=enabled \
                       -Dgbm=disabled \
                       -Dh264=disabled"
