# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="graphene"
PKG_VERSION="1.10.8"
PKG_SHA256="a37bb0e78a419dcbeaa9c7027bcff52f5ec2367c25ec859da31dfde2928f279a"
PKG_LICENSE="MIT"
PKG_SITE="https://ebassi.github.io/graphene/"
PKG_URL="https://download.gnome.org/sources/${PKG_NAME}/${PKG_VERSION:0:4}/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain glib"
PKG_LONGDESC="A thin layer of types for graphic libraries."

PKG_MESON_OPTS_TARGET="-Dgtk_doc=false \
                       -Dintrospection=disabled \
                       -Dtests=false \
                       -Dinstalled_tests=false"
