# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2020-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="encodings"
PKG_VERSION="1.1.0"
PKG_SHA256="38dc8ed1e1f04376e1895a53dc1719c9f80bac61636b8be9f6191c5e02fd7913"
PKG_TOOLCHAIN="meson"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/font/encodings/-/archive/encodings-1.1.0/encodings-encodings-1.1.0.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros font-util:host"
PKG_LONGDESC="X font encoding meta files."

PKG_MESON_OPTS_TARGET="-Dgzip-small-encodings=true \
                       -Dgzip-large-encodings=true \
                       -Dfontrootdir=/usr/share/fonts"
