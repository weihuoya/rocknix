# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)

PKG_NAME="libplacebo"
PKG_VERSION="7.351.0"
PKG_LICENSE="GPLv2+"
PKG_SITE="https://code.videolan.org/videolan/libplacebo"
PKG_URL="https://github.com/haasn/libplacebo/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_SHA256="716954501d9b76e6906fddda66febc5886493d0673dd265ec1e6e52f4e5cd7c6"
PKG_DEPENDS_TARGET="toolchain ffmpeg SDL2 luajit libass glslang"
PKG_LONGDESC="The core rendering algorithms and ideas of mpv rewritten as an independent library."

if [ "${VULKAN_SUPPORT}" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" ${VULKAN}"
  PKG_MESON_OPTS_TARGET+=" -Dvulkan=enabled"
else
  PKG_MESON_OPTS_TARGET+=" -Dvulkan=disabled"
fi

pre_configure_target() {
  export TARGET_LDFLAGS="${LDFLAGS} -lglslang"
}
