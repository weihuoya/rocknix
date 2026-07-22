# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="gobject-introspection"
PKG_VERSION="1.86.0"
PKG_SHA256="920d1a3fcedeadc32acff95c2e203b319039dd4b4a08dd1a2dfd283d19c0b9ae"
PKG_LICENSE="GPL"
PKG_SITE="https://gi.readthedocs.io/"
PKG_URL="https://download.gnome.org/sources/${PKG_NAME}/${PKG_VERSION:0:4}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="libffi:host pcre2:host Python3:host meson:host ninja:host glib:host"
PKG_DEPENDS_TARGET="toolchain Python3 glib libffi pcre2"
PKG_LONGDESC="GObject introspection tools and libraries for generating and using introspection data."
PKG_BUILD_FLAGS="-sysroot"

PKG_MESON_OPTS_HOST="-Dcairo=disabled \
                     -Ddoctool=disabled \
                     -Dgtk_doc=false \
                     -Dtests=false \
                     -Dbuild_introspection_data=false"

PKG_MESON_OPTS_TARGET="-Dcairo=disabled \
                       -Ddoctool=disabled \
                       -Dgtk_doc=false \
                       -Dtests=false \
                       -Dbuild_introspection_data=false \
                       -Dgi_cross_use_prebuilt_gi=true"
