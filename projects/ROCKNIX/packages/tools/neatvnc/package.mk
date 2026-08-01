# SPDX-License-Identifier: ISC
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="neatvnc"
PKG_VERSION="3c1e0c6ce4aa49f99c0e706b0e4a7141d0202f62"
PKG_GIT_CLONE_BRANCH="master"
PKG_LICENSE="ISC"
PKG_SITE="https://github.com/weihuoya/neatvnc"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain pixman aml libjpeg-turbo gnutls nettle gmp libdrm libpng zlib ffmpeg mesa"
PKG_LONGDESC="A Neat VNC server library"
GET_HANDLER_SUPPORT="git"

PKG_MESON_OPTS_TARGET="-Dexamples=false \
                       -Dbenchmarks=false \
                       -Dtests=false \
                       -Djpeg=enabled \
                       -Dtls=enabled \
                       -Dnettle=enabled \
                       -Dgbm=enabled \
                       -Dh264=enabled"
