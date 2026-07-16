# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libXss"
PKG_VERSION="1.2.5"
PKG_SHA256="59db6cfa413aed52dfcac8ab61895580903330164199fc8765fe31d21215f7ff"
PKG_TOOLCHAIN="meson"
PKG_LICENSE="OSS"
PKG_SITE="https://www.X.org"
PKG_URL="https://gitlab.freedesktop.org/xorg/lib/libxscrnsaver/-/archive/libXScrnSaver-1.2.5/libxscrnsaver-libXScrnSaver-1.2.5.tar.bz2"
PKG_DEPENDS_TARGET="toolchain util-macros libXext"
PKG_LONGDESC="X11 Screen Saver extension library."

PKG_MESON_OPTS_TARGET="-Ddefault_library=shared"
