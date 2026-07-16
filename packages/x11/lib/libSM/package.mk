# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libSM"
PKG_VERSION="1.2.6"
PKG_SHA256="63a827e5804b3240a3739f2221a5d2444a6f0dc05a3974ff1fb12824e3c18e73"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="http://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libsm/-/archive/libSM-1.2.6/libsm-libSM-1.2.6.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros util-linux libICE"
PKG_LONGDESC="This package provides the main interface to the X11 Session Management library."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-static \
                           --disable-shared \
                           --with-libuuid \
                           --without-xmlto \
                           --without-fop"
