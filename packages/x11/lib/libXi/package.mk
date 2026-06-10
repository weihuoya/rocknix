# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libXi"
PKG_VERSION="1.8.2"
PKG_SHA256="718b8c864d62c21b8a1217e3e2d705e962624600f9861b006fbce333c90b9527"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.x.org/"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxi/-/archive/libXi-1.8.2/libxi-libXi-1.8.2.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libX11 libXfixes libXext"
PKG_LONGDESC="LibXi provides an X Window System client interface to the XINPUT extension to the X protocol."
PKG_BUILD_FLAGS="+pic"

PKG_CONFIGURE_OPTS_TARGET="--enable-malloc0returnsnull \
                           --disable-silent-rules \
                           --disable-docs \
                           --disable-specs \
                           --without-xmlto \
                           --without-fop \
                           --without-xsltproc \
                           --without-asciidoc \
                           --with-gnu-ld"

post_configure_target() {
  libtool_remove_rpath libtool
}
