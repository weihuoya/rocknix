# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="cargo-snapshot"
PKG_VERSION="$(get_pkg_version rust)"
PKG_LICENSE="MIT"
PKG_SITE="https://www.rust-lang.org"
PKG_LONGDESC="cargo bootstrap package"
PKG_TOOLCHAIN="manual"

case "${MACHINE_HARDWARE_NAME}" in
  "aarch64")
    PKG_SHA256="e271c3c5d50336259a166e68b60ba792a64278ab117686183be3e51a0958d34b"
    PKG_URL="https://static.rust-lang.org/dist/cargo-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnu.tar.gz"
    ;;
  "arm")
    PKG_SHA256="614c88e28a17996411a025e22552e96b59289f9566701fe9bbb0f8ab62a2d198"
    PKG_URL="https://static.rust-lang.org/dist/cargo-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnueabihf.tar.gz"
    ;;
  "x86_64")
    PKG_SHA256="18bf1598891b30dd5eb52a337d08a92b4456255ddbe4c1ab996ffb578077031c"
    PKG_URL="https://static.rust-lang.org/dist/cargo-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnu.tar.gz"
    ;;
esac
PKG_SOURCE_NAME="cargo-snapshot_${PKG_VERSION}_${ARCH}.tar.gz"
