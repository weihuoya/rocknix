# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="gtk4"
PKG_VERSION="4.22.4"
PKG_SHA256="acadda507c54b7c75c1284a4e816b33c3db3e5e2acff33272af863f5b155d952"
PKG_LICENSE="LGPL"
PKG_SITE="https://www.gtk.org/"
PKG_URL="https://gitlab.gnome.org/GNOME/gtk/-/archive/${PKG_VERSION}/gtk-${PKG_VERSION}.tar.bz2"
PKG_SOURCE_DIR="gtk-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain at-spi2-core cairo gdk-pixbuf glib gobject-introspection graphene gstreamer gst-plugins-base libepoxy pango libxkbcommon wayland wayland-protocols vulkan-loader vulkan-headers"
PKG_DEPENDS_CONFIG="cairo pango gdk-pixbuf shared-mime-info"
PKG_LONGDESC="GTK 4 toolkit for creating graphical user interfaces."
PKG_BUILD_FLAGS="-sysroot"

PKG_MESON_OPTS_TARGET="-Dwayland-backend=true \
                       -Dx11-backend=false \
                       -Dbroadway-backend=false \
                       -Dwin32-backend=false \
                       -Dmacos-backend=false \
                       -Dandroid-backend=false \
                       -Dmedia-gstreamer=enabled \
                       -Dprint-cpdb=disabled \
                       -Dprint-cups=disabled \
                       -Dvulkan=enabled \
                       -Dcloudproviders=disabled \
                       -Dsysprof=disabled \
                       -Dtracker=disabled \
                       -Dcolord=disabled \
                       -Df16c=auto \
                       -Daccesskit=disabled \
                       -Dandroid-runtime=disabled \
                       -Dintrospection=enabled \
                       -Ddocumentation=false \
                       -Dman-pages=false \
                       -Dbuild-demos=false \
                       -Dbuild-examples=false \
                       -Dbuild-tests=false \
                       -Dbuild-testsuite=false"

post_makeinstall_target() {
  ${TOOLCHAIN}/bin/glib-compile-schemas ${INSTALL}/usr/share/glib-2.0/schemas
}
