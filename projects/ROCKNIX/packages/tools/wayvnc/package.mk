# SPDX-License-Identifier: ISC
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="wayvnc"
PKG_VERSION="0.10.1"
PKG_SHA256="1dcb54f58d1637995bfb59c17709efca7833bae41f31b33eb47e608668a89d66"
PKG_LICENSE="ISC"
PKG_SITE="https://github.com/any1/wayvnc"
PKG_URL="https://github.com/any1/wayvnc/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain aml neatvnc pixman libdrm libxkbcommon wayland jansson"
PKG_LONGDESC="A VNC server for wlroots based Wayland compositors"

# Allow a local checkout to be used instead of fetching from git.
# Set WAYVNC_SOURCE_DIR in the environment to the path containing wayvnc's source.
if [ -n "${WAYVNC_SOURCE_DIR}" ]; then
  PKG_URL=""
  GET_HANDLER_SUPPORT=""
else
  PKG_URL="https://github.com/any1/wayvnc/archive/refs/tags/v${PKG_VERSION}.tar.gz"
fi

unpack() {
  if [ -n "${WAYVNC_SOURCE_DIR}" ]; then
    mkdir -p "${PKG_BUILD}"
    cp -a "${WAYVNC_SOURCE_DIR}/." "${PKG_BUILD}/"
  fi
}

PKG_MESON_OPTS_TARGET="-Dscreencopy-dmabuf=enabled \
                       -Dpam=disabled \
                       -Dman-pages=disabled \
                       -Dtests=false"

pre_configure_target() {
  # wayvnc uses -Wmissing-field-initializers which is treated as a warning,
  # but some configurations enable -Werror; keep the build lenient.
  export TARGET_CFLAGS=$(echo "${TARGET_CFLAGS} -Wno-missing-field-initializers")
}
