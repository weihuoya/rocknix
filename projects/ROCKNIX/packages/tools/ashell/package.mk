# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2026-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="ashell"
PKG_VERSION="main"
PKG_LICENSE="GPL-3.0-or-later"
PKG_SITE="https://github.com/weihuoya/ashell"
PKG_DEPENDS_TARGET="toolchain cargo:host rust wayland wayland-protocols libxkbcommon vulkan-headers vulkan-loader fontconfig freetype harfbuzz libxcb libX11 libXcursor libXrandr libXi libXinerama libXrender libXext libXfixes libXau"
PKG_LONGDESC="A GPUI based SSH and local terminal client"
PKG_TOOLCHAIN="manual"

# Allow a local checkout to be used instead of fetching from git.
# Set ASHELL_SOURCE_DIR in the environment to the path containing ashell's source.
if [ -n "${ASHELL_SOURCE_DIR}" ]; then
  PKG_URL=""
  GET_HANDLER_SUPPORT=""
else
  PKG_GIT_CLONE_BRANCH="main"
  PKG_URL="${PKG_SITE}.git"
  GET_HANDLER_SUPPORT="git"
fi

unpack() {
  if [ -n "${ASHELL_SOURCE_DIR}" ]; then
    mkdir -p "${PKG_BUILD}"
    cp -a "${ASHELL_SOURCE_DIR}/." "${PKG_BUILD}/"
  fi
}

make_target() {
  cd ${PKG_BUILD}

  # Allow CI to persist downloaded crates across runs by pointing CARGO_HOME at a
  # host-mounted directory. If unset, fall back to the build-system default.
  if [ -n "${CARGO_HOME_OVERRIDE}" ]; then
    export CARGO_HOME="${CARGO_HOME_OVERRIDE}"
    mkdir -p "${CARGO_HOME}"
  fi

  # Cargo needs a host linker for build-scripts/proc-macros and a target linker
  # for the final binary. The rust cache does not ship the global cargo config,
  # so provide a project-local one.
  mkdir -p ${PKG_BUILD}/.cargo
  HOST_TRIPLE=$(rustc -vV | sed -n 's|host: ||p')
  cat > ${PKG_BUILD}/.cargo/config.toml <<EOF
[target.${HOST_TRIPLE}]
linker = "/usr/bin/gcc"

[target.${TARGET_NAME}]
linker = "${TARGET_PREFIX}gcc"
EOF

  cargo build --release --target ${TARGET_NAME}
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
    cp ${PKG_BUILD}/.${TARGET_NAME}/target/${TARGET_NAME}/release/ashell ${INSTALL}/usr/bin/
}
