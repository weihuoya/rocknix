# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="libadwaita"
PKG_VERSION="1.6.2"
PKG_SHA256="7542f8354e6808dd4e9a31551bbdfc0170735e4af4d1b3e69186500ccb9c01eb"
PKG_LICENSE="LGPL"
PKG_SITE="https://gitlab.gnome.org/GNOME/libadwaita"
PKG_URL="https://download.gnome.org/sources/libadwaita/1.6/libadwaita-${PKG_VERSION}.tar.xz"
PKG_SOURCE_DIR="libadwaita-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain gtk4 glib"
PKG_LONGDESC="Building blocks for modern GNOME applications."
PKG_BUILD_FLAGS="-sysroot"

PKG_MESON_OPTS_TARGET=""