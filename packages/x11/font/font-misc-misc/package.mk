# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="font-misc-misc"
PKG_VERSION="1.1.3"
PKG_SHA256="01b933ca20717f4f25b0bde983361254b6bd6be5affa0857167f97c3cdac41a5"
PKG_TOOLCHAIN="autotools"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/font/misc-misc/-/archive/font-misc-misc-1.1.3/misc-misc-font-misc-misc-1.1.3.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros font-util font-cursor-misc"
PKG_LONGDESC="A misc. public domain font."

PKG_CONFIGURE_OPTS_TARGET="--with-fontrootdir=/usr/share/fonts \
                           --disable-silent-rules \
                           --enable-iso8859-1 \
                           --enable-iso8859-2 \
                           --disable-iso8859-3 \
                           --disable-iso8859-4 \
                           --enable-iso8859-5 \
                           --enable-iso8859-7 \
                           --enable-iso8859-8 \
                           --enable-iso8859-9 \
                           --disable-iso8859-10 \
                           --disable-iso8859-11 \
                           --disable-iso8859-13 \
                           --enable-iso8859-14 \
                           --enable-iso8859-15 \
                           --disable-iso8859-16 \
                           --disable-koi8-r \
                           --disable-jisx0201"

PKG_MAKE_OPTS_TARGET="UTIL_DIR=${SYSROOT_PREFIX}/usr/share/fonts/util/"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/fonts/misc
    cp 6x13-ISO8859-1.pcf.gz ${INSTALL}/usr/share/fonts/misc
}

post_install() {
  mkfontdir ${INSTALL}/usr/share/fonts/misc
  mkfontscale ${INSTALL}/usr/share/fonts/misc
}
