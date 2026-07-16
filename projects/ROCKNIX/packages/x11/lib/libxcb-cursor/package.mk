# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libxcb-cursor"
PKG_VERSION="0.1.6"
PKG_LICENSE="OSS"
PKG_SITE="https://gitlab.freedesktop.org/xorg/lib/libxcb-cursor"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxcb-cursor/-/archive/xcb-util-cursor-0.1.6/libxcb-cursor-xcb-util-cursor-0.1.6.tar.bz2"
PKG_SHA256="7bd65f259cfe8a95def9d21e6c3c87e75bef550fccddb06a458dfa1026f7e011"
PKG_DEPENDS_TARGET="toolchain xcb-proto libxcb xcb-util-renderutil xcb-util-image"
PKG_LONGDESC="Port of libXcursor."
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="autotools"
