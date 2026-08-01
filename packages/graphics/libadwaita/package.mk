# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libadwaita"
PKG_VERSION="1.9.2"
PKG_SHA256="8fc4d558acb10e237cdeb1b25247f0559c59956b99a7c1d41c1dc786fa21c953"
PKG_LICENSE="LGPL"
PKG_SITE="https://gitlab.gnome.org/GNOME/libadwaita"
PKG_URL="https://gitlab.gnome.org/GNOME/libadwaita/-/archive/${PKG_VERSION}/libadwaita-${PKG_VERSION}.tar.bz2"
PKG_SOURCE_DIR="libadwaita-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain gtk4 glib"
PKG_LONGDESC="Building blocks for modern GNOME applications."
PKG_BUILD_FLAGS="-sysroot"

PKG_MESON_OPTS_TARGET="-Dtests=false \\
                       -Dvapi=false \\
                       -Dintrospection=disabled \\
                       -Dgtk_doc=false \\
                       -Dexamples=false"

