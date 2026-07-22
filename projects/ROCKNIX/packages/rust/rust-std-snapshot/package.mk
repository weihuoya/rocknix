# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="rust-std-snapshot"
PKG_VERSION="$(get_pkg_version rust)"
PKG_LICENSE="MIT"
PKG_SITE="https://www.rust-lang.org"
PKG_LONGDESC="rust std library bootstrap package"
PKG_TOOLCHAIN="manual"

case "${MACHINE_HARDWARE_NAME}" in
  "aarch64")
    PKG_SHA256="ae6c76b70be4768ecf2f320f1e6fa28525730b7fd7d6cfc822a3a23e0c07fcc2"
    PKG_URL="https://static.rust-lang.org/dist/rust-std-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnu.tar.gz"
    ;;
  "arm")
    PKG_SHA256="d789fd5bf9df5060c5ce9b95cecdb6f176d1c626520d50b474fbd0604096220f"
    PKG_URL="https://static.rust-lang.org/dist/rust-std-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnueabihf.tar.gz"
    ;;
  "x86_64")
    PKG_SHA256="26abd06b9c4221811af1baec86dfb6de9535862fc853b85388dcc314c96cea6d"
    PKG_URL="https://static.rust-lang.org/dist/rust-std-${PKG_VERSION}-${MACHINE_HARDWARE_NAME}-unknown-linux-gnu.tar.gz"
    ;;
esac
PKG_SOURCE_NAME="rust-std-snapshot_${PKG_VERSION}_${ARCH}.tar.gz"
