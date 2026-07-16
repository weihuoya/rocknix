# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xcb-proto"
PKG_VERSION="1.17.0"
PKG_SHA256="15f0c8d596b84916a42e8e5e6d9c29230327eb8889a902f07d67d65c7e5d8004"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/proto/xcbproto/-/archive/xcb-proto-1.17.0/xcbproto-xcb-proto-1.17.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros Python3:host"
PKG_LONGDESC="X C-language Bindings protocol headers."
PKG_BUILD_FLAGS="-cfg-libs"

post_makeinstall_target() {
  python_remove_source
}
