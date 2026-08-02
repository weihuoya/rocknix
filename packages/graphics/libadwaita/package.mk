# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libadwaita"
PKG_VERSION="1.8.6"
PKG_SHA256="87ece2f8d8ac4043766a7b87697e1f2b6925bbe3560e6f915066f9c88a6b9827"
PKG_LICENSE="LGPL"
PKG_SITE="https://gitlab.gnome.org/GNOME/libadwaita"
PKG_URL="https://gitlab.gnome.org/GNOME/libadwaita/-/archive/${PKG_VERSION}/libadwaita-${PKG_VERSION}.tar.bz2"
PKG_SOURCE_DIR="libadwaita-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain gtk4 glib"
PKG_LONGDEC="Building blocks for modern GNOME applications."
PKG_BUILD_FLAGS="-sysroot"

PKG_MESON_OPTS_TARGET="-Dtests=false \
                       -Dcapi=false \
                       -Dintrospection=disabled \
                       -Dgtk_doc=false \
                       -Dexamples=false"
